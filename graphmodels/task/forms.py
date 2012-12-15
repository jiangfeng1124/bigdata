from django import forms
from models import Task

class SubmitTaskForm(forms.ModelForm):
  class Meta:
    model = Task
