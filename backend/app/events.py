from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def geteventsDB(request):
    """
    TODO: Edit so that request gets all events for a user
    """
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    # json_data = json.loads(request.body)
    # username = json_data['userid']
    username = request.GET.get('userid')
    cursor.execute('SELECT title, start, "end", type, userids, taskid, eventid FROM events WHERE (%s) = ANY(userids) ORDER BY start DESC;', (username,))  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = []
    for row in rows:
        tempdict = {}
        tempdict['eventid'] = row[-1]
        tempdict['title'] = row[0]
        tempdict['start'] = row[1]
        tempdict['end'] = row[2]
        tempdict['type'] = row[3]
        tempdict['users'] = row[4]
        tempdict['related_task_id'] = row[5]
        response.append(tempdict)
    
    return JsonResponse({"content":response})

def createeventDB(request):
    """
        TODO: Implement this
    """
    return JsonResponse({})

def editorDeleteEventDB(request, eventid):
    """
    TODO: Implement this
    """
    return JsonResponse({})

def getEventsForTaskDB(request, taskid):
    """
    TODO: Implement this
    """
    return JsonResponse({})
