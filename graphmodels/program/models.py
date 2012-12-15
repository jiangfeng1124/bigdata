from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Program(models.Model):
  owner = models.ForeignKey(User)
  path = models.CharField(max_length=200)
  name = models.CharField(max_length=50)
  language = models.CharField(max_length=20)
  create_date = models.DateTimeField()
  options = models.CharField(max_length=100, blank=True)
  options_desc = models.CharField(max_length=200, blank=True)
  description = models.CharField(max_length=500)
  access = models.CharField(max_length=10)
  task_num = models.IntegerField()

  def __unicode__(self):
    return u'%s' % (self.name)
