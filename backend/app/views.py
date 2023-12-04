from app.autosched import *
from app.tasks import *
from app.events import *
from app.groups import *
from app.gcal import *
from app.users import *
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

# TASK API CALLS
@require_http_methods(["POST"])
def gettasks(request):
    return gettasksDB(request)

@csrf_exempt
@require_http_methods(["POST"])
def posttask(request):
    return posttasksDB(request)

@csrf_exempt
@require_http_methods(["PUT", "DELETE"])
def editorDeleteTask(request, taskid):
    if request.method == "PUT":
        return edittasksDB(request, taskid)
    else:
        return deletetaskDB(request, taskid)


# GROUP API CALLS
@require_http_methods(["POST"])
def getgroups(request):
    return getgroupsDB(request)

@csrf_exempt
@require_http_methods(["POST"])
def postgroups(request):
    return postgroupsDB(request)

@csrf_exempt
@require_http_methods(["PUT", "DELETE"])
def editOrDeleteGroups(request, groupid):
    if request.method == "PUT":
        return editgroupDB(request, groupid)
    else:
        return deletegroupDB(request, groupid)


# SCHEDULE API CALLS
@csrf_exempt
@require_http_methods(["POST"])
def autoschedule(request, taskid):
    return autoscheduleDB(request, taskid)

@csrf_exempt
@require_http_methods(["POST"])
def postgoogle(request):
    return postgoogleDB(request)

#EVENT/CALENDAR API CALLS
@require_http_methods(["POST"])
def getevents(request):
    return geteventsDB(request)

@csrf_exempt
@require_http_methods(["POST"])
def createevent(request):
    return createeventDB(request)

@csrf_exempt
@require_http_methods(["PUT", "DELETE"])
def editorDeleteEvent(request, eventid):
    return editorDeleteEventDB(request, eventid)

@csrf_exempt
@require_http_methods(["POST"])
def getEventsForTask(request, taskid):
    return getEventsForTaskDB(request, taskid)

# USER AUTHENTICATION CALLS
@csrf_exempt
@require_http_methods(["POST"])
def login(request):
    return loginDB(request)

@csrf_exempt
@require_http_methods(["POST"])
def signup(request):
    return signupDB(request)

@csrf_exempt
@require_http_methods(["POST"])
def getProfileInfo(request):
    return getUserProfileInfoDB(request)
