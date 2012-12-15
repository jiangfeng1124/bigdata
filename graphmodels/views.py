
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.template import Context
from django.template import RequestContext
from django.template.loader import get_template
from django.conf import settings
from django.db.models import Q

def index(request):

  if request.user.is_authenticated():
    user = request.user
  else:
    user = request.user

  return render_to_response("homepage.html", RequestContext(request, {'user': user}))

