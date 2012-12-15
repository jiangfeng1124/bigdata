from django import forms
from models import Dataset

class UploadDatasetForm(forms.ModelForm):
  class Meta:
    model = Dataset
