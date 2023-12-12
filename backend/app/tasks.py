from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

from django.db import transaction
import app.users
from routing.celery import app
from app.gcal import updateCalendar


@app.task
def updating():
    cursor = connection.cursor()
    cursor.execute("Select * from users;")
    rows = cursor.fetchall()
    for row in rows:
        updateCalendar(row[0])


def gettasksDB(request):
    """
    TODO: Edit function so that it returns tasks for authenticated user.
    User authentication must be completed first"""  # need to search the table for tasks that match the userid ?????

    # token = request.headers["authorization"]
    username = json.loads(request.body)['userid']
    # do authorization ?????

    cursor = connection.cursor()
    # cursor.execute('SELECT title, duration, due_date, description, userids, scheduled FROM tasks ORDER BY userids DESC;')
    cursor.execute(
        'SELECT title, duration, due_date, description, userids, group_id, scheduled, taskid FROM tasks WHERE (%s) = ANY(userids);', (username,))
    rows = cursor.fetchall()

    response = []
    for row in rows:
        tempdict = {}
        tempdict['taskid'] = row[-1]
        tempdict['title'] = row[0]
        tempdict['duration'] = row[1]
        tempdict['due_date'] = row[2]
        tempdict['description'] = row[3]
        tempdict['users'] = []
        tempdict['scheduled'] = row[6]
        tempdict['groupd_id'] = row[5]

        for user in row[4]:
            cursor = connection.cursor()
            cursor.execute(
                'SELECT userid, fname, lname, email FROM users WHERE (%s) = userid;', (user,))
            rows = cursor.fetchall()

            curr_user = rows[0]
            # response['userid'] = curr_user[0]
            # response['first_name'] = curr_user[1]
            # response['last_name'] = curr_user[2]
            # response['email'] = curr_user[3]
            tempdict['users'].append(
                {"userid": curr_user[0], "fname": curr_user[1], "lname": curr_user[2]})

        response.append(tempdict)

    return JsonResponse(response, safe=False)


def posttasksDB(request):
    """
    TODO: Edit fields so that it matches API definition on Github page. 
    Postgres table needs to be updated with assigned_users and group.
    taskid isn't passed in the request, it is generated here or in postgres. 
    """  # generate the taskid !!!!!!!!

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
    # cursor.execute('INSERT INTO tasks (tasktitle, groupid, timeneeded, duedate, description, userid) VALUES '
    #        '(%s, %s, %s, %s, %s, %s );', (tasktitle, groupid, timeneeded, duedate, description, userid))
    cursor.execute('INSERT INTO tasks (title, duration, due_date, description, userids, scheduled) VALUES '
                   '(%s, %s, %s, %s, %s, %s) RETURNING taskid;', (title, duration, due_date, description, userids, scheduled))

    taskid = cursor.fetchone()[0]
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

    cursor.execute('UPDATE tasks SET title = %s, duration=%s, due_date=%s, description=%s, userids=%s, scheduled=%s '
                   'WHERE taskid = %s;', (title, duration, due_date,
                                          description, userids, scheduled, taskid)
                   )  # this might need to be edited !!!!!!!!

    return JsonResponse({'id': taskid})


def deletetaskDB(request, taskid):
    """
    TODO: Implement this function
    """  # change this to a DELETE staements where it searches for the specifc task in table

    if request.method != 'DELETE':
        return HttpResponse(status=404)

    cursor = connection.cursor()
    cursor.execute(f'DELETE FROM tasks WHERE taskid = {taskid};')

    return JsonResponse({"message": "Task successfully deleted", "taskid": taskid})
