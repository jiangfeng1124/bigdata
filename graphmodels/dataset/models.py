from django.db import models
from django.contrib.auth.models import User

# Create your models here.
def file_name(instance, filename):
  return '/'.join([instance.user.username, filename])

class Dataset(models.Model):
  owner = models.ForeignKey(User)
  path = models.CharField(max_length=200)
  name = models.CharField(max_length=50)
  description = models.CharField(max_length=200)
  dim = models.IntegerField()
  size = models.IntegerField()
  sep = models.CharField(max_length=10)
  header = models.BooleanField()
  access = models.CharField(max_length=10)

  def __unicode__(self):
    return u'%s' % (self.name)

