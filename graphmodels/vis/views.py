# Create your views here.

from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from forms import UploadVisForm
from models import Vis
from django.conf import settings
from django.contrib.auth.decorators import login_required
from django.db.models import Q
import os
import datetime
import simplejson
import pickle

@login_required
def vis_view(request):

    user = request.user

    vis_list = Vis.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')

    return render_to_response("vis/view.html", RequestContext(request, {'user': user, 'vis_list': vis_list}))

def vis_info(request, offset):

    user = request.user

    try:
        vis_id = int(offset)
    except ValueError:
        raise Http404()

    vis = Vis.objects.filter(Q(id=vis_id))
    if len(vis) == 0:
        vis_list = Vis.objects.filter(Q(owner__id=user.id) | Q(access="public")).order_by('-id')
        notice = "Couldn't find Task with ID=" + str(vis_id)
        return render_to_response('vis/view.html', RequestContext(request, {'user': user, 'vis_list': vis_list, 'notice': notice}))
    
    vis = vis[0]
    if vis.progress != "visualized":
        return render_to_response("vis/info.html", RequestContext(request, {'vis': vis, 'status': "0"}))
    
    vis_res_path = os.path.join(settings.USR_VIS_ROOT)
    f_graph_json = open(os.path.join(vis_res_path, str(vis_id), "graph.json"))
    graph_json_data = simplejson.load(f_graph_json)
    graph_json_data = simplejson.dumps(graph_json_data)
  
    f_icov_json = open(os.path.join(vis_res_path, str(vis_id), "icov.json"))
    icov_json_data = simplejson.load(f_icov_json)
    icov_json_data = simplejson.dumps(icov_json_data)
  
    f_degree = open(os.path.join(vis_res_path, str(vis_id), "graph.degree"))
    degree_tbl = pickle.load(f_degree)
  
    result_graph = os.path.join("/vresult", str(vis_id), "graph.png")
    circos_png = os.path.join("/vresult", str(vis_id), "circos.png")
    circos_svg = os.path.join("/vresult", str(vis_id), "circos.svg")
    return render_to_response('vis/info.html', RequestContext(request, {'vis': vis, 'status': "1", 'result_graph': result_graph, 'circos_png': circos_png, 'circos_svg': circos_svg, 'graph_json_data': graph_json_data, 'degree_tbl': degree_tbl, 'icov_json_data': icov_json_data}))

@login_required
def vis_upload(request):

  user = request.user

  if request.method == 'POST':
    if user.is_authenticated():

      file = request.FILES.get('filename', '')

      file_name = file.name
      dest_dir = os.path.join(settings.USR_VDATASET_ROOT, user.username)
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
      dim = 0
      for line in open(full_path):
        dim += 1
      if header == True:
        dim -= 1 # exclude the header line

      create_date = datetime.datetime.now()
      new_vis = Vis(owner = user, data_path = rel_path, data_name = file_name, data_dim = dim, data_description = description, create_date = create_date, progress = "waiting", access = access, data_sep = sep_str, data_header = header)
      new_vis.save()
      new_vis_id = new_vis.id
      new_vis.result_dir = str(new_vis_id)
      new_vis.save()

      notice = "Congratulations! Your dataset has been successfully uploaded."
      # return render_to_response('dataset/success.html', RequestContext(request, {'dataset': new_dataset, 'notice': notice}))
      return HttpResponseRedirect('/vis/%s/' % new_vis.id)

    else:
      notice = "You must be logged in to upload datasets"
      form = UploadVisForm()
      return render_to_response('vis/upload.html', RequestContext(request, {'form': form, 'notice': notice}))

  else:
    form = UploadVisForm()
    return render_to_response('vis/upload.html', RequestContext(request, {'form': form}))

