#!/bin/python
import MySQLdb
import time
import os
import DBConf
import simplejson
import pickle
import sys
sys.path.append("..")
import settings

# connect to the database
db = MySQLdb.connect(user=DBConf.USERNAME, db=DBConf.DATABASE, passwd=DBConf.PASSWD, host=DBConf.HOST)
cursor = db.cursor()
cursor.connection.autocommit(True)

while True:
    
    time.sleep(2)

    query_vis = 'SELECT * FROM vis_vis where progress="waiting" ORDER BY create_date'
    cursor.execute(query_vis)

    vis_to_process = cursor.fetchall()
    n = len(vis_to_process)

    for i in range(0, n):

        vis_id = vis_to_process[i][0]
        update_vis = 'UPDATE vis_vis SET progress="processing" where id=' + str(vis_id)
        print update_vis
        cursor.execute(update_vis)
        print "Visualizing vis#", vis_id

        data_path = os.path.join(settings.USR_VDATASET_ROOT, vis_to_process[i][2])
        data_name = vis_to_process[i][3]
        data_sep = vis_to_process[i][6]
        data_header = vis_to_process[i][7]
        print "data: ", data_name

        result_dir = os.path.join(settings.USR_VIS_ROOT, vis_to_process[i][10])
        if not os.path.exists(result_dir):
            os.makedirs(result_dir)

        icov_path = data_path
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

        # print "data_sep: " + data_sep
        tbl_separator = {"tab":"\t", "comma":",", "semicolon":";", "space":" "}
        sep = tbl_separator[data_sep]
        nodenames = []
        if data_header == 1:
            nodenames = f_mat.readline().strip().split(sep)
        else:
            dim = len(f_mat.readline().strip().split(sep))
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

            icov_row = [float(e) for e in line.strip().split(sep)]
            omega_row = [0 if e == 0 else 1 for e in icov_row]

            # the degree of a node is sum(omega_row)-1 to exclude itself
            key = sum(omega_row) if omega_row[i] == 0 else (sum(omega_row)-1)
            degree_info[key] = degree_info.get(key, 0) + 1

            # do not plot the nodes with 0 degree
            if key == 0:
                i += 1
                continue

            # node_info = "chr - hs" + str(i+1) + " " + nodenames[i] + " 0 1 chr" + str((i+1)%24) + "\n"
            # f_circos_nodes.write(node_info) 

            dim = sum(omega_row) * 2
            if dim > 8: dim = 8
            if dim < 4: dim = 4
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

        # f_circos_nodes.close()
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

        update_vis = 'UPDATE vis_vis SET progress="processed" where id=' + str(vis_id)

        print update_vis
        cursor.execute(update_vis)

