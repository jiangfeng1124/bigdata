# Create your views here.

from django.http import HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from forms import UploadProgramForm
from models import Program
from django.conf import settings
from django.contrib.auth.decorators import login_required
from django.db.models import Q
import os

@login_required
def program_view(request):

  user = request.user
  program_list = Program.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
  return render_to_response("program/view.html", RequestContext(request, {'user': user, 'program_list': program_list}))

def program_upload(request):

  user = request.user

  if request.method == 'POST':
    if user.is_authenticated():

      file = request.FILES.get('filename', '')

      file_name = file.name
      dest_dir = os.path.join(settings.USR_PROGRAM_ROOT, user.username)
      if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
				# os.chmod(dest_dir, 0775)

      full_path = os.path.join(dest_dir, file_name)
      destination = open(full_path, "wb+")
      for chunk in file.chunks():
        destination.write(chunk)
      destination.close()

      language = request.POST['lang']
      description = request.POST['description']
      access = request.POST['access']
      new_program = Program(owner = user, path = full_path, name = file_name, language = language, description = description, access = access)
      new_program.save()

      notice = "Congratulations! Your model has been successfully uploaded."
      return render_to_response('program/success.html', RequestContext(request, {'program': new_program, 'notice': notice}))

    else:
      notice = "You must be logged in to upload programs"
      form = UploadProgramForm()
      return render_to_response('program/upload.html', RequestContext(request, {'form': form, 'notice': notice}))

  else:
    form = UploadProgramForm()
    return render_to_response('program/upload.html', RequestContext(request, {'form': form}))

