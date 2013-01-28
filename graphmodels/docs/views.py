# Create your views here.

from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response

def docs_intro(request):
    return render_to_response("docs/intro.html", RequestContext(request))

def docs_feature(request):
    return render_to_response("docs/feature.html", RequestContext(request))

def docs_dataset(request):
    return render_to_response("docs/dataset.html", RequestContext(request))

def docs_api(request):
    return render_to_response("docs/api.html", RequestContext(request))

def docs_about(request):
    return render_to_response("docs/about.html", RequestContext(request))

def docs_contact(request):
    return render_to_response("docs/contact.html", RequestContext(request))

