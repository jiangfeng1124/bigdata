from graphmodels.dataset.models import Dataset
from django.contrib import admin

class DatasetAdmin(admin.ModelAdmin):
  pass

admin.site.register(Dataset, DatasetAdmin)
