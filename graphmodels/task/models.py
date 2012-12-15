from django.db import models
from django.contrib.auth.models import User
from graphmodels.dataset.models import Dataset
from graphmodels.program.models import Program 

# Create your models here.

class Task(models.Model):
  owner = models.ForeignKey(User)
  data = models.ForeignKey(Dataset)
  program = models.ForeignKey(Program)
  options = models.CharField(max_length=100, blank=True)
  create_date = models.DateTimeField()
  progress = models.CharField(max_length=20)
  result_dir = models.CharField(max_length=200)
  access = models.CharField(max_length=10)

  def __unicode__(self):
    return u'%s' % (self.owner.username + "_" + self.data.name + "_" + self.program.name)
