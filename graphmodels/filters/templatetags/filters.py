#!/bin/python

from django import template
from datetime import *
from time import *
from django.utils.timesince import timesince
from django.utils.timezone import utc
register = template.Library()

def append(value, arg):
  return str(value)+str(arg)

def time_until(value):
  now = datetime.utcnow().replace(tzinfo=utc)
  try:
    difference = now - value 
  except:
    return value

  print now
  print value
  print difference
  if difference <= timedelta(minutes=1):
    return 'just now'
  return '%(time)s ago' % {'time': timesince(value).split(', ')[0]}

def length(value):
  return len(value)

register.filter('append', append)
register.filter('time_until', time_until)
