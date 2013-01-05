#!/bin/python

import MySQLdb
import time
import sys
import os

sys.path.append("..")
import DBConf

sys.path.append("../..")
import settings

db = MySQLdb.connect(user=DBConf.USERNAME, db=DBConf.DATABASE, passwd=DBConf.PASSWD, host=DBConf.HOST)
cursor = db.cursor()

while True:

  time.sleep(1)

  query_task = 'SELECT * FROM task_task where progress="processed" ORDER BY create_date'
  cursor.execute(query_task)

  tasks_to_visualize = cursor.fetchall()
  n = len(tasks_to_visualize)

  for i in range(0, n):
    
    task_id = tasks_to_visualize[i][0]
    update_task = 'UPDATE task_task SET progress="visualizing" where id=' + str(task_id)
    cursor.execute(update_task)
    print "Visualizing task#", task_id

    result_dir = os.path.join(settings.USR_RESULT_ROOT, tasks_to_visualize[i][6])
    circos_nodes_path = result_dir + "/circos.nodes"
    circos_links_path = result_dir + "/circos.links"

    visual_command = ("circos", "-conf circos.conf", "-usertext1", circos_nodes_path, "-usertext2", circos_links_path, "-outputdir", result_dir, "-silent")
    visual_command = " ".join(visual_command)

    visual_result = os.system(visual_command)

    if visual_result == 0:
      update_task = 'UPDATE task_task SET progress="visualized" where id=' + str(task_id)
    else:
      update_task = 'UPDATE task_task SET progress="failed" where id=' + str(task_id)

    print update_task
    cursor.execute(update_task)

