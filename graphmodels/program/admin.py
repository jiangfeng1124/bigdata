from graphmodels.program.models import Program
from django.contrib import admin

class ProgramAdmin(admin.ModelAdmin):
  pass

admin.site.register(Program, ProgramAdmin)
