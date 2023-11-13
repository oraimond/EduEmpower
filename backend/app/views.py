from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json


def gettasks(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    cursor = connection.cursor()
    cursor.execute('SELECT userid, fname, lname FROM tasks ORDER BY lname DESC;')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = {}
    response['tasks'] = rows
    return JsonResponse(response)
@csrf_exempt
def posttask(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    userid = json_data['userid']
    fname = json_data['fname']
    lname = json_data['lname']

    cursor = connection.cursor()
    cursor.execute('INSERT INTO tasks (userid, fname, lname) VALUES '
                   '(%s, %s, %s);', (userid, fname, lname))

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

scopes = ['https://www.googleapis.com/auth/calendar']
@csrf_exempt
def postgoogle(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    idToken = json_data['idToken']     # user's OpenID ID Token, a JSon Web Token (JWT)
    accessToken = json_data['accessToken']
    refreshToken = json_data['refreshToken']
    now = time.time()                  # secs since epoch (1/1/70, 00:00:00 UTC)

    with open('credentials.json', 'f') as credentials:
        data = json.load(credentials)
        clientID = data['client_ID']
        client_secret = data['client_secret']



    try:
        # Collect user info from the Google idToken, verify_oauth2_token checks
        # the integrity of idToken and throws a "ValueError" if idToken or
        # clientID is corrupted or if user has been disconnected from Google
        # OAuth (requiring user to log back in to Google).
        # idToken has a lifetime of about 1 hour
        idinfo = id_token.verify_oauth2_token(idToken, requests.Request(), clientID)
    except ValueError:
        # Invalid or expired token
        return HttpResponse(status=511)  # 511 Network Authentication Required

    credentials = Credentials.from_authorized_user_info(
        {
            'client_id': clientID,
            'client_secret': client_secret,
            'token': None,
            'id_token': idToken,
            'refresh_token': refresh_token,
            'token_uri': 'https://oauth2.googleapis.com/token',
            'scopes': scopes,
            'default_scopes': scopes  # Adjust the scope as needed
        }
    )

    service = build("calendar", "v3", credentials)

    result = service.calendarList().list().execute()

    calendar_id = result['items'][0]

    events = service.events().list(calendarID=calendar_id).exec

    events = events['items'][0]

    query = """INSERT INTO events (eventtype, endtime, starttime, note)
                VALUES """
    for event in events:
        end = event["end"]
        start = event["start"]
        note = event["summary"]
        query = query + f"""(\'gcal\', \'{end}\', \'{start}\', \'{note}\'),"""


    query = query[:-1] + ";"

    cursor = connection.cursor()

    cursor.execute(query)
    # get username
    try:
        username = idinfo['name']
    except:
        username = "Profile NA"



    # Return chatterID and its lifetime
    return events

# Create your views here.
