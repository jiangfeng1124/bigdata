# Create your views here.

from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from forms import UploadDatasetForm
from models import Dataset
from graphmodels.program.models import Program
from graphmodels.task.models import Task
from django.conf import settings
from django.contrib.auth.decorators import login_required
from django.db.models import Q
import os

@login_required
def dataset_view(request):

  user = request.user
  dataset_list = Dataset.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
  return render_to_response("dataset/view.html", RequestContext(request, {'user': user, 'dataset_list': dataset_list}))

@login_required
def dataset_info(request, offset):

  user = request.user
  try:
    dataset_id = int(offset)
  except ValueError:
    raise Http404()

  dataset = Dataset.objects.filter(Q(id=dataset_id))
  if len(dataset) == 0:
    dataset_list = Dataset.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
    notice = "Couldn't find Dataset with ID=" + str(dataset_id)
    return render_to_response('dataset/view.html', RequestContext(request, {'user': user, 'dataset_list': dataset_list, 'notice': notice}))

  program_list = Program.objects.all();
  dataset = dataset[0]
  related_task_list = Task.objects.filter(Q(data__id=dataset.id) & Q(access="public")).order_by('-id')

  return render_to_response('dataset/info.html', RequestContext(request, {'dataset': dataset, 'program_list': program_list, 'related_tasks': related_task_list}))


def dataset_upload(request):

  user = request.user

  if request.method == 'POST':
    if user.is_authenticated():

      file = request.FILES.get('filename', '')

      file_name = file.name
      dest_dir = os.path.join(settings.USR_DATASET_ROOT, user.username)
      if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)

      full_path = os.path.join(dest_dir, file_name)
      rel_path = os.path.join(user.username, file_name)
      destination = open(full_path, "wb+")
      for chunk in file.chunks():
        destination.write(chunk)
      destination.close()

      description = request.POST['description']
      access = request.POST['access']
      tbl_separator = {"tab":'\t', "space":' ', "comma":',', "semicolon":';'}
      sep_str = request.POST['sep']
      sep = tbl_separator[sep_str]
      header = request.POST['header']
      if header == 'yes':
        header = True;
      elif header == 'no':
        header = False;

      ## a simple check
      size = 0
      for line in open(full_path):
        size += 1
      dim = len(line.split(sep))
      if header == True:
        size -= 1 # exclude the header line

      new_dataset = Dataset(owner = user, path = rel_path, name = file_name, dim = dim, size = size, description = description, access = access, sep = sep_str, header = header)
      new_dataset.save()

      notice = "Congratulations! Your dataset has been successfully uploaded."
      # return render_to_response('dataset/success.html', RequestContext(request, {'dataset': new_dataset, 'notice': notice}))
      return HttpResponseRedirect('/datasets/%s/' % new_dataset.id)

    else:
      notice = "You must be logged in to upload datasets"
      form = UploadDatasetForm()
      return render_to_response('dataset/upload.html', RequestContext(request, {'form': form, 'notice': notice}))

  else:
    form = UploadDatasetForm()
    return render_to_response('dataset/upload.html', RequestContext(request, {'form': form}))

