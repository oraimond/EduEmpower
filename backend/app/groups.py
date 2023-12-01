from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def getgroupsDB(request):
    """
    TODO: Ensure that groups returned are for specific user
    """ # similar to tasks, ensure that we search in the table for userid and not all groups !!!!!!
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT groupid, title, userids FROM usergroups ORDER BY userids DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['usergroups'] = rows
    return JsonResponse(response)

def postgroupsDB(request):
    """
    TODO: Only parameters passed through are title and users.
    Have to generate groupid. 
    userids aren't passed in request, just usernames. 
    Will change to store usernames in DB
    """
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

def editgroupDB(request, groupid):
    """
    TODO: Implement this function
    """ #should be similar to task equivalent 
    return JsonResponse({})

def deletegroupDB(request, groupid):
    """
    TODO: Implement this function
    """ #should be same as task equivalent 
    return JsonResponse({})
