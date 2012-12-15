# Create your views here.

from django.shortcuts import render_to_response
from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import authenticate, login, logout
from django.db.models import Q
from django.contrib.auth.models import User

def register(request):
  if request.method == 'POST':
    form = UserCreationForm(request.POST)
    if form.is_valid():
      new_user = form.save()
      username = request.POST['username']
      password = request.POST['password1']
      user = authenticate(username=username, password=password)
      login(request, user)
      return HttpResponseRedirect('/')
    else:
      username = request.POST['username']
      password1 = request.POST['password1']
      password2 = request.POST['password2']
      if User.objects.filter(username=username).count():
        notice = "username already taken"
      elif password1 != password2:
        notice = "password not consistent"
      form = UserCreationForm()
      return render_to_response("registration/register.html", RequestContext(request, {'form': form, 'notice': notice}))
  else:
    form = UserCreationForm()
    return render_to_response("registration/register.html", RequestContext(request, {'form': form}))

def profile(request):
  return render_to_response('registration/profile.html', RequestContext(request))

