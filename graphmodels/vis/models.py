from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Vis(models.Model):
    owner = models.ForeignKey(User)
    data_path = models.CharField(max_length=200)
    data_name = models.CharField(max_length=50)
    data_description = models.CharField(max_length=200)
    data_dim = models.IntegerField()
    data_sep = models.CharField(max_length=10)
    data_header = models.BooleanField()
    create_date = models.DateTimeField()
    progress = models.CharField(max_length=20)
    result_dir = models.CharField(max_length=200)
    access = models.CharField(max_length=10)

    def __unicode__(self):
        return u'%s' % (self.data_name)

