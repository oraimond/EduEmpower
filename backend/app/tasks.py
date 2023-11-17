from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def gettasksDB(request):
    """
    TODO: Edit function so that it returns tasks for authenticated user.
    User authentication must be completed first"""
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    #cursor.execute('SELECT taskid, tasktitle, groupid, timeneeded, duedate, description, userid FROM tasks ORDER BY userid DESC;')  # not sure what fields we wanted
    cursor.execute('SELECT title, duration, due_date, description, userids, scheduled FROM tasks ORDER BY userids DESC;')
    rows = cursor.fetchall()

    response = {}
    response['tasks'] = rows
    return JsonResponse(response)

def posttasksDB(request):
    """
    TODO: Edit fields so that it matches API definition on Github page. 
    Postgres table needs to be updated with assigned_users and group.
    taskid isn't passed in the request, it is generated here or in postgres. 
    """
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    title = json_data['title']
    duration = json_data['duration']
    due_date = json_data['due_date']
    description = json_data['description']
    userids = json_data['userids']
    scheduled = json_data['scheduled']
    cursor = connection.cursor()
    #cursor.execute('INSERT INTO tasks (taskid, tasktitle, groupid, timeneeded, duedate, description, userid) VALUES '
           #        '(%s, %s, %s, %s, %s, %s, %s );', (taskid, tasktitle, groupid, timeneeded, duedate, description, userid))
    cursor.execute('INSERT INTO tasks (title, duration, due_date, description, userids, scheduled) VALUES '
                   '(%s, %s, %s, %s, %s, %s );', (title, duration, due_date, description, userids, scheduled))
    
    return JsonResponse({})

def edittasksDB(request, taskid):
    """
    TODO: Implement this function
    """
    return JsonResponse({})

def deletetaskDB(request, taskid):
    """
    TODO: Implement this function
    """
    member = Member.objects.get(id=id)  # needs testing
    member.delete()
    return JsonResponse({})
