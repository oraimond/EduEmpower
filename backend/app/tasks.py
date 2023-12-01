from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

from django.db import transaction
from sequences import get_next_value

def gettasksDB(request):
    """
    TODO: Edit function so that it returns tasks for authenticated user.
    User authentication must be completed first""" # need to search the table for tasks that match the userid ?????
    if request.method != 'GET':
        return HttpResponse(status=404)

    username, token = request.headers["authorization"]

    # do authorization ?????
    
    cursor = connection.cursor()
    #cursor.execute('SELECT title, duration, due_date, description, userids, scheduled FROM tasks ORDER BY userids DESC;')
    cursor.execute('SELECT title, duration, due_date, description, userids, scheduled FROM tasks WHERE (%s) IN userids;', (username,))
    rows = cursor.fetchall()

    response = {}
    response['tasks'] = rows
    return JsonResponse(response)

def posttasksDB(request):
    """
    TODO: Edit fields so that it matches API definition on Github page. 
    Postgres table needs to be updated with assigned_users and group.
    taskid isn't passed in the request, it is generated here or in postgres. 
    """  # generate the taskid !!!!!!!!
    taskid = get_next_value("tasks")
    
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
    cursor.execute('INSERT INTO tasks (title, duration, due_date, description, userids, scheduled. taskid) VALUES '
                   '(%s, %s, %s, %s, %s, %s );', (title, duration, due_date, description, userids, scheduled, taskid))
    
    return JsonResponse({'id': taskid})

def edittasksDB(request, taskid):
    """
    TODO: Implement this function
    """

    if request.method != 'PUT':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    title = json_data['title']
    duration = json_data['duration']
    due_date = json_data['due_date']
    description = json_data['description']
    userids = json_data['userids']
    scheduled = json_data['scheduled']
    cursor = connection.cursor()

    cursor.execute('UPDATE tasks SET (title, duration, due_date, description, userids, scheduled) VALUES '
                   '(%s, %s, %s, %s, %s, %s ) WHERE taskid = %s;', (title, duration, due_date, description, userids, scheduled, taskid) 
                   ) # this might need to be edited !!!!!!!!
                   
    
    return JsonResponse({'id': taskid})

def deletetaskDB(request, taskid):
    """
    TODO: Implement this function
    """ #change this to a DELETE staements where it searches for the specifc task in table

    if request.method != 'DELETE':
        return HttpResponse(status=404)

    cursor = connection.cursor()
    cursor.execute('DELETE FROM tasks WHERE taskid = %s;' (taskid,))
    
    
    
    return JsonResponse({"message": "Task successfully deleted", "taskid": taskid })
