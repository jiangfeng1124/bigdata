## tags.py

from django import template
register = template.Library()

def active(request, pattern):
    import re
    if re.search(pattern, request.path):
        return 'current_view'
    return ''

register.simple_tag(active)
