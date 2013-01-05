# Create your views here.

from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from forms import SubmitTaskForm
from graphmodels.dataset.models import Dataset
from graphmodels.program.models import Program
from models import Task
from django.db.models import Q
from django.conf import settings
from django.contrib.auth.decorators import login_required
import datetime
import os
import simplejson
import pickle

@login_required
def task_view(request):
  
  user = request.user
  task_list = Task.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
  return render_to_response("task/view.html", RequestContext(request, {'user': user, 'task_list': task_list}))

@login_required
def task_info(request, offset):
  
  user = request.user
  try:
    task_id = int(offset)
  except ValueError:
    raise Http404()

  task = Task.objects.filter(Q(id=task_id))
  if len(task) == 0:
    task_list = Task.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
    notice = "Couldn't find Task with ID=" + str(task_id)
    return render_to_response('task/view.html', RequestContext(request, {'user': user, 'task_list': task_list, 'notice': notice}))

  task = task[0]
  if task.progress != "visualized":
    return render_to_response('task/info.html', RequestContext(request, {'task': task, 'status': "0"}))

  data_path = os.path.join(settings.USR_RESULT_ROOT)
  f_graph_json = open(os.path.join(data_path, str(task_id), "graph.json"))
  graph_json_data = simplejson.load(f_graph_json)
  graph_json_data = simplejson.dumps(graph_json_data)

  f_icov_json = open(os.path.join(data_path, str(task_id), "icov.json"))
  icov_json_data = simplejson.load(f_icov_json)
  icov_json_data = simplejson.dumps(icov_json_data)

  f_degree = open(os.path.join(data_path, str(task_id), "graph.degree"))
  degree_tbl = pickle.load(f_degree)

  result_graph = os.path.join("/result", str(task_id), "graph.png")
  circos_png = os.path.join("/result", str(task_id), "circos.png")
  circos_svg = os.path.join("/result", str(task_id), "circos.svg")
  return render_to_response('task/info.html', RequestContext(request, {'task': task, 'status': "1", 'result_graph': result_graph, 'circos_png': circos_png, 'circos_svg': circos_svg, 'graph_json_data': graph_json_data, 'degree_tbl': degree_tbl, 'icov_json_data': icov_json_data}))

def task_submit(request):

  user = request.user

  if user.is_authenticated():

    dataset_list = Dataset.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('id')
    program_list = Program.objects.all()

    if request.method == 'POST':

      data_id = request.POST.get('data', 0)
      program_id = request.POST.get('program', 0)
      print data_id, program_id

      if data_id and program_id:

        query_dataset = (Q(id=data_id))
        dataset = Dataset.objects.filter(query_dataset)[0]

        query_program = (Q(id=program_id))
        program = Program.objects.filter(query_program)[0]
        task_options = request.POST["options_"+str(program_id)]

        create_date = datetime.datetime.now()
        access = request.POST["access"]

        new_task = Task(owner = user, data = dataset, program = program, options = task_options, create_date = create_date, progress = "waiting", result_dir = "", access = access)

        new_task.save()
        new_task_id = new_task.id
        #result_dir = os.path.join(settings.USR_RESULT_ROOT, str(new_task_id))
        #if not os.path.exists(result_dir):
        #  os.makedirs(result_dir)
        new_task.result_dir = str(new_task_id) # relative path
        new_task.save()

        return render_to_response("task/success.html", RequestContext(request, {'user': user, 'new_task': new_task}))
      else:
        if not data_id:
          notice = "Please select a dataset."
        else:
          notice = "Please select a model."
        return render_to_response("task/submit.html", RequestContext(request, {'user': user, 'dataset_list': dataset_list, 'program_list': program_list, 'notice': notice}))

    else:
      return render_to_response("task/submit.html", RequestContext(request, {'user': user, 'dataset_list': dataset_list, 'program_list': program_list}))

  else:
    notice = "You should be logged in to submit a new task."
    return render_to_response('task/submit.html', RequestContext(request, {'notice': notice}))

@login_required
def task_new(request):

  user = request.user

  dataset_id = request.GET.get('dataset_id', '')
  program_id = request.GET.get('model_id', '')

  try:
    dataset_id = int(dataset_id)
    program_id = int(program_id)
  except ValueError:
    raise Http404();

  if request.method == 'POST':
    query_dataset = (Q(id=dataset_id))
    dataset = Dataset.objects.filter(query_dataset)[0]

    query_program = (Q(id=program_id))
    program = Program.objects.filter(query_program)[0]
    task_options = request.POST["options"]

    create_date = datetime.datetime.now()
    access = request.POST["access"]

    new_task = Task(owner = user, data = dataset, program = program, options = task_options, create_date = create_date, progress = "waiting", result_dir = "", access = access)

    new_task.save()
    program.task_num += 1
    program.save()

    new_task_id = new_task.id
    #result_dir = os.path.join(settings.USR_RESULT_ROOT, str(new_task_id))
    #if not os.path.exists(result_dir):
    #  os.makedirs(result_dir)
    new_task.result_dir = str(new_task_id)
    new_task.save()

    # return render_to_response("task/success.html", RequestContext(request, {'user': user, 'new_task': new_task}))
    return HttpResponseRedirect("/tasks/%s/" % new_task.id)
  else:
    dataset = Dataset.objects.filter(Q(id=dataset_id))
    program = Program.objects.filter(Q(id=program_id))
    if len(dataset) == 0 or len(program) == 0:
      notice="Couldn't find the dataset(ID="+str(dataset_id)+")or model(ID="+str(program_id)+")"
      return render_to_response('task/error.html', RequestContext(request, {'notice': notice}))

    dataset = dataset[0]
    program = program[0]
    dataset_name = dataset.name
    program_name = program.name

    return render_to_response('task/new.html', RequestContext(request, {'dataset_id': dataset_id, 'program_id': program_id, 'dataset_name': dataset_name, 'program_name': program_name}))
