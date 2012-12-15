from django import forms
from models import Program 

class UploadProgramForm(forms.ModelForm):
  class Meta:
    model = Program
