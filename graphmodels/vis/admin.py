from graphmodels.vis.models import Vis 
from django.contrib import admin

class VisAdmin(admin.ModelAdmin):
  pass

admin.site.register(Vis, VisAdmin)
