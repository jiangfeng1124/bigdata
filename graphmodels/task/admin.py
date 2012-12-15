from graphmodels.task.models import Task
from django.contrib import admin

class TaskAdmin(admin.ModelAdmin):
  pass

admin.site.register(Task, TaskAdmin)
