from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def getgroupsDB(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT groupid, title, userids FROM usergroups ORDER BY userids DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['usergroups'] = rows
    return JsonResponse(response)

def postgroupsDB(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    groupid = json_data['groupid']
    title = json_data['title']
    userids = json_data['userids']

    cursor = connection.cursor()
    cursor.execute('INSERT INTO usergroups (groupid, title, userids) VALUES '
                   '(%s, %s, %s);', (groupid, title, userids))

    return JsonResponse({})