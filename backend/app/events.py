from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def geteventsDB(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT eventtype, endtime, starttime, note, eventid FROM events ORDER BY starttime DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['events'] = rows
    return JsonResponse(response)