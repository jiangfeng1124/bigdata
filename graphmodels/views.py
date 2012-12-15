from django.template.loader import get_template
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.template import Context
from django.template import RequestContext
from dataset.models import Dataset
from program.models import Program
from django.conf import settings
from task.models import Task
import datetime
import os
import simplejson
from django.db.models import Q

#from upload.models import Upload
#from django.forms import UploadFileForm
from dataset.forms import UploadDatasetForm

def hello(request):
  return HttpResponse("Hello, World!")

def current_datetime(request):
  #now = datetime.datetime.now()
  #t = get_template("current_datetime.html")
  #html = t.render(Context({'current_date':now}))
  #return HttpResponse(html)
  current_date = datetime.datetime.now()
  return render_to_response('current_datetime.html', locals())

def hours_ahead(request, offset):
  try:
    hour_offset = int(offset)
  except ValueError:
    raise Http404()
  next_time = datetime.datetime.now() + datetime.timedelta(hours=hour_offset)
  return render_to_response('hours_ahead.html', locals())

def index(request):
  if request.user.is_authenticated():
    user = request.user
  else:
    user = request.user

  dataset_list = Dataset.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
  dataset_display_num = 7 if len(dataset_list) > 7 else len(dataset_list)
  dataset_list = dataset_list[0:dataset_display_num]
  program_list = Program.objects.filter(Q(owner__id=user.id) | Q(access="public"))
  task_list = Task.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
  task_display_num = 16 if len(task_list) > 16 else len(task_list)
  task_list = task_list[0:task_display_num]

  if request.method == 'POST':
    task_id = request.POST['id']
    query_task = (Q(id=task_id))
    task = Task.objects.filter(query_task)[0]

    result_dir = task.result_dir 
    task_id = task.id
    #result_precision = os.path.join("/result", user_name, dataset_name+"_"+program_name, "precision.png")
    #result_cv = os.path.join("/result", user_name, dataset_name+"_"+program_name, "cv.png")
    result_graph = os.path.join("/result", str(task_id), "graph.png")

    return render_to_response("index.html", RequestContext(request, {'user': user, 'dataset_list': dataset_list, 'program_list': program_list, 'task_list': task_list, 'result_dir': result_dir, 'result_graph': result_graph, 'task_id': task_id}))

  return render_to_response("homepage.html", RequestContext(request, {'user': user, 'dataset_list': dataset_list, 'program_list': program_list, 'task_list': task_list}))

