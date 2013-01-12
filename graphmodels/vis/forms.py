from django import forms
from models import Vis

class UploadVisForm(forms.ModelForm):
  class Meta:
    model = Vis
