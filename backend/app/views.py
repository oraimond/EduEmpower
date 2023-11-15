from app.autosched import *
from app.tasks import *
from app.events import *
from app.groups import *
from app.gcal import *

def gettasks(request):
    return gettasksDB(request)

@csrf_exempt
def posttask(request):
    return posttasksDB(request)
    
def getevents(request):
    return geteventsDB(request)
    
def getgroups(request):
    return getgroupsDB(request)

@csrf_exempt
def postgroups(request):
    return postgroupsDB(request)
    
def autoschedule(request):
    return

@csrf_exempt
def postgoogle(request):
    return postgoogleDB(request)


# Create your views here.
