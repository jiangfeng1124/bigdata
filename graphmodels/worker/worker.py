#!/bin/python
import MySQLdb
import time
import shutil
import os
import DBConf
import simplejson
import pickle
import sys
sys.path.append("..")
import settings
# os.environ['DJANGO_SETTINGS_MODULE'] = "graphmodels.settings"

# connect to the database
db = MySQLdb.connect(user=DBConf.USERNAME, db=DBConf.DATABASE, passwd=DBConf.PASSWD, host=DBConf.HOST)
cursor = db.cursor()

# read waiting(unprocessed or newly submitted) tasks every 5 seconds;
while True:

  time.sleep(1)

  query_task = 'SELECT * FROM task_task where progress="waiting" ORDER BY create_date'
  cursor.execute(query_task)

  tasks_to_process = cursor.fetchall()
  n = len(tasks_to_process)

  for i in range(0, n):

    # set the progress of the specified task to be "processing"
    task_id = tasks_to_process[i][0]
    update_task = 'UPDATE task_task SET progress="processing" where id=' + str(task_id)
    cursor.execute(update_task)
    print "Executing task#", task_id

    owner_id = tasks_to_process[i][1]

    # get the path of dataset
    data_id = tasks_to_process[i][2]
    query_data_path = 'SELECT path, name, sep, header FROM dataset_dataset where id=' + str(data_id)
    cursor.execute(query_data_path)
    (data_path, data_name, data_sep, data_header) = cursor.fetchall()[0]
    data_path = settings.USR_DATASET_ROOT + data_path
    print "data: ", data_name

    # get the path of model
    program_id = tasks_to_process[i][3]
    query_program_path = 'SELECT path, name, language FROM program_program where id=' + str(program_id)
    cursor.execute(query_program_path)
    (program_path, program_name, program_lang) = cursor.fetchall()[0]
    program_path = settings.USR_PROGRAM_ROOT + program_path
    query_task_options = 'SELECT options FROM task_task where id=' + str(task_id)
    cursor.execute(query_task_options)
    task_options = cursor.fetchall()[0][0]
    print "model: ", program_name, " writen in ", program_lang, " with options: [ ", task_options, "]"

    result_dir = os.path.join(settings.USR_RESULT_ROOT, tasks_to_process[i][6])
    if not os.path.exists(result_dir):
      os.makedirs(result_dir)

    if program_lang == "R":
      icov_path = result_dir + "/icov.mat"
      program_path = os.path.join(program_path, "run.R")
      run_command = ("Rscript", program_path, task_options, data_sep, str(data_header), data_path, icov_path)
      run_command = " ".join(run_command)
    else:
      icov_path = result_dir + "/icov.mat"
      program_path = os.path.join(program_path, "run.py")
      run_command = ("python", program_path, task_options, data_sep, str(data_header), data_path, icov_path)
      run_command = " ".join(run_command)

    prog_result = os.system(run_command)

    if prog_result != 0:
      print "retry..."
      prog_result = os.system(run_command)

    # generate the json tree from the matrix data
    if prog_result == 0:

      f_mat = open(icov_path, "r")

      graph_json_path = result_dir + "/graph.json"
      f_graph_json = open(graph_json_path, "w")

      icov_json_path = result_dir + "/icov.json"
      f_icov_json = open(icov_json_path, "w")

      degree_path = result_dir + "/graph.degree"
      f_degree = open(degree_path, "w")

      circos_nodes_path = result_dir + "/circos.nodes"
      f_circos_nodes = open(circos_nodes_path, "w")
      circos_links_path = result_dir + "/circos.links"
      f_circos_links = open(circos_links_path, "w")

      nodenames = []
      if data_header == 1:
        nodenames = f_mat.readline().strip().split()
      else:
        dim = len(f_mat.readline().strip().split())
        for i in range(1, dim+1):
          nodenames.append("V"+str(i))
        f_mat.seek(0) # return to the beginning

      # write nodes info(ideograms) to "circos.nodes"
      for i in range(0, len(nodenames)):
        node_info = "chr - hs" + str(i+1) + " " + nodenames[i] + " 0 1 chr" + str((i+1)%24) + "\n"
        f_circos_nodes.write(node_info) 
      f_circos_nodes.close()

      graph_json = []
      degree_info = {}
      icov_json = {}
      icov_json["cols"] = [{"id":"A", "label":"Node1", "type":"string"},
                           {"id":"B", "label":"Node2", "type":"string"},
                           {"id":"C", "label":"Partial Correlation", "type":"number"}]
      icov_json["rows"] = []

      i = 0
      for line in f_mat.readlines():

        icov_row = [float(e) for e in line.strip().split()]
        omega_row = [0 if e == 0 else 1 for e in icov_row]

        # the degree of a node is sum(omega_row)-1 to exclude itself
        degree_info[sum(omega_row)-1] = degree_info.get(sum(omega_row)-1, 0) + 1
        dim = sum(omega_row) * 2
        if dim > 12: dim = 12
        if dim < 5: dim = 5
        node = {}
        node_adjacencies = []
        node["id"] = nodenames[i]
        node["name"] = node["id"]
        node["data"] = {"$color":"#83548B", "$type":"circle", "$dim":dim}

        for col in range(i+1, len(omega_row)):

          icov_json_row = {}
          icov_json_row["c"] = []

          if omega_row[col] != 0:
            edge = {}
            edge["nodeTo"] = nodenames[col]
            edge["nodeFrom"] = nodenames[i]
            edge["data"] = {"$color":"#557EAA"}
            node_adjacencies.append(edge)

            icov_json_row_item1 = {}
            icov_json_row_item1["v"] = nodenames[i]
            icov_json_row_item2 = {}
            icov_json_row_item2["v"] = nodenames[col]
            icov_json_row_item3 = {}
            icov_json_row_item3["v"] = icov_row[col]
            icov_json_row["c"].append(icov_json_row_item1)
            icov_json_row["c"].append(icov_json_row_item2)
            icov_json_row["c"].append(icov_json_row_item3)

            icov_json["rows"].append(icov_json_row)

            # add a circos link
            link_info = "hs" + str(i+1) + " 0 1 hs" + str(col+1) + " 0 1\n"
            f_circos_links.write(link_info)

        node["adjacencies"] = node_adjacencies
        graph_json.append(node)
        i += 1

      f_circos_links.close()

      simplejson.dump(graph_json, f_graph_json, indent="\t")
      f_graph_json.close()

      simplejson.dump(icov_json, f_icov_json, indent="\t")
      f_icov_json.close()

      degree_table = []
      degree_table.append(["degree", "frequency"])
      for key in sorted(degree_info.iterkeys(), reverse = True):
        degree_table.append([str(key), degree_info[key]])

      pickle.dump(degree_table, f_degree)
      f_degree.close()

      update_task = 'UPDATE task_task SET progress="processed" where id=' + str(task_id)
    else:
      update_task = 'UPDATE task_task SET progress="failed" where id=' + str(task_id)

    print update_task
    cursor.execute(update_task)


    # update the status of that task as "processed"
    #if prog_result == 0:
    #  # visualize the graph
    #  visualize_path = "./visualize.R"
    #  visualize_command = ("Rscript", visualize_path, result_dir, program_lang)
    #  visualize_command = " ".join(visualize_command)
    #  visual_result = os.system(visualize_command)
    #  if visual_result == 0:
    #    update_task = 'UPDATE task_task SET progress="processed" where id=' + str(task_id)
    #  else:
    #    update_task = 'UPDATE task_task SET progress="visual failed" where id=' + str(task_id)
    #else:
    #  update_task = 'UPDATE task_task SET progress="failed" where id=' + str(task_id)

    #print update_task
    #cursor.execute(update_task)

