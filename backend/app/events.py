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
    cursor.execute('SELECT eventtype, endtime, starttime, note, eventid FROM events ORDER BY starttime DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['events'] = rows
    return JsonResponse(response)

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