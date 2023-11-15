from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
from apiclient.discovery import build
from google_auth_oauthlib.flow import Flow
from datetime import datetime
from datetime import timedelta

def gettasks(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT taskid, tasktitle, groupid, timeneeded, duedate, description, userid FROM tasks ORDER BY userid DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['tasks'] = rows
    return JsonResponse(response)
@csrf_exempt
def posttask(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    taskid = json_data['taskid']
    tasktitle = json_data['tasktitle']
    groupid = json_data['groupid']
    timeneeded = json_data['timeneeded']
    duedate = json_data['duedate']
    description = json_data['description']
    userid = json_data['userid']
    cursor = connection.cursor()
    cursor.execute('INSERT INTO tasks (taskid, tasktitle, groupid, timeneeded, duedate, description, userid) VALUES '
                   '(%s, %s, %s, %s, %s, %s, %s );', (taskid, tasktitle, groupid, timeneeded, duedate, description, userid))

    return JsonResponse({})
    
def getevents(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT eventtype, endtime, starttime, note, eventid FROM events ORDER BY starttime DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['events'] = rows
    return JsonResponse(response)
    
def getgroups(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT groupid, title, userids FROM usergroups ORDER BY userids DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['usergroups'] = rows
    return JsonResponse(response)

@csrf_exempt
def postgroups(request):
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
    
def autoschedule(request):
    return


@csrf_exempt
def postgoogle(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    scopes = ['https://www.googleapis.com/auth/calendar', 'https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/calendar.events', 'openid']
    CLIENT_SECRET_FILE = "app/client_secret.json"
    
    flow = Flow.from_client_secrets_file(CLIENT_SECRET_FILE, scopes)
    flow.redirect_uri = ""
    
    auth_code = json.loads(request)['auth_code']

    try:
        flow.fetch_token(code=auth_code)
    except Error as e:
        return e
    
    sess = flow.authorized_session()
    
    timeMin = datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
    timeMax = (datetime.now() + timedelta(365)).strftime("%Y-%m-%dT%H:%M:%SZ")
    
    try:
        response = sess.request("GET", f"https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin={timeMin}&timeMax={timeMax}&singleEvents=true&orderBy=startTime")
        response.raise_for_status()
    except requests.exceptions.HTTPError as e:
        return e
    

    calendar = response.json()["items"]

    





    # Return chatterID and its lifetime
    return events

# Create your views here.
