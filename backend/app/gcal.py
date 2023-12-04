from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from google.oauth2.credentials import Credentials
import json
from google_auth_oauthlib.flow import Flow
from google_auth_oauthlib.flow import InstalledAppFlow
from datetime import datetime
from datetime import timedelta
import requests


def insertGCal(userid, name, start, end):
    scopes = ['https://www.googleapis.com/auth/calendar', 'https://www.googleapis.com/auth/userinfo.email',
              'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/calendar.events',
              'openid']
    CLIENT_SECRET_FILE = "app/client_secret.json"

    flow = InstalledAppFlow.from_client_secrets_file(
        CLIENT_SECRET_FILE,
        scopes=scopes
    )
    cursor = connection.cursor()

    query = f'''
        SELECT * FROM users WHERE userid = \'{userid}\';
        '''
    user = cursor.execute(query)
    user = cursor.fetchone()
    for i in user:
        print(i)
    print(user[5])
    print(user[3])

    refresh_token = user[5]
    if refresh_token == "":
        return
    params = {
        'refresh_token': refresh_token,
        'client_id': flow.client_config['client_id'],
        'client_secret': flow.client_config['client_secret'],
        'grant_type': 'refresh_token'
    }

    r = requests.post(
        url='https://oauth2.googleapis.com/token',
        params=params
    )

    requestURL = "https://www.googleapis.com/calendar/v3/calendars/primary/events"

    event = {
        "summary": name,
        "start": {
            'dateTime': start
        },
        'end': {
            'dateTime': end,
        },
    }

    creds = r.json()
    auth_header = {'Authorization': f'Bearer {creds["access_token"]}'}
    try:
        response = requests.post(url=requestURL, json=event, headers=auth_header)
    except Exception as e:
        print(e)

def updateCalendar(userid):
    scopes = ['https://www.googleapis.com/auth/calendar', 'https://www.googleapis.com/auth/userinfo.email',
              'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/calendar.events',
              'openid']
    CLIENT_SECRET_FILE = "app/client_secret.json"

    flow = InstalledAppFlow.from_client_secrets_file(
        CLIENT_SECRET_FILE,
        scopes=scopes
    )
    cursor = connection.cursor()

    query = f'''
    SELECT * FROM users WHERE userid = \'{userid}\';
    '''
    user = cursor.execute(query)
    user = cursor.fetchone()
    refresh_token = user[5]
    if refresh_token == "":
        return
    params = {
        'refresh_token': refresh_token,
        'client_id': flow.client_config['client_id'],
        'client_secret': flow.client_config['client_secret'],
        'grant_type': 'refresh_token'
    }

    r = requests.post(
        url='https://oauth2.googleapis.com/token',
        params=params
    )
    timeMin = datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
    timeMax = (datetime.now() + timedelta(365)).strftime("%Y-%m-%dT%H:%M:%SZ")

    creds = r.json()
    if "access_token" not in creds:
        return
    calendarRequest = f"https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin={timeMin}&timeMax={timeMax}&singleEvents=true&orderBy=startTime"
    auth_header = {'Authorization': f'Bearer {creds["access_token"]}'}
    response = requests.get(url=calendarRequest, headers=auth_header)
    events = response.json()['items']

    for event in events:
        if 'dateTime' not in event['start'] or 'dateTime' not in event['end']:
            continue
        print(event)
        try:
            start = event['start']['dateTime'].replace("T", " ")
            end = event['end']['dateTime'].replace("T", " ")
            summary = event['summary']
            id = event['id']
        except TypeError as e:
            print(e)
            return
        checkQuery = f"""
                SELECT * FROM EVENTS WHERE start = \'{start}\' AND "end" = \'{end}\';
                """
        cursor.execute(checkQuery)
        isEvent = cursor.fetchone()
        if isEvent:
            continue
        
        query = f"""
        INSERT INTO events (title, start, "end", type, userids) VALUES (\'{summary}\', \'{start}\', \'{end}\', \'gcal\', ARRAY[\'{userid}\'])
        """
        cursor.execute(query)


def postgoogleDB(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    scopes = ['https://www.googleapis.com/auth/calendar', 'https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/calendar.events', 'openid']
    CLIENT_SECRET_FILE = "app/client_secret.json"
    
    flow = Flow.from_client_secrets_file(CLIENT_SECRET_FILE, scopes)
    flow.redirect_uri = ""
    cursor = connection.cursor()
    request_content = json.loads(request.body)

    auth_code = request_content['auth_code']
    username = request_content['userid']

    flow.fetch_token(code=auth_code)
    credentials = flow.credentials

    refresh_token = credentials.refresh_token

    query = f"""
    UPDATE users
    SET refresh_token = \'{refresh_token}\'
    WHERE userid =\'{username}\';
    """
    cursor.execute(query)
    
    sess = flow.authorized_session()
    
    timeMin = datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
    timeMax = (datetime.now() + timedelta(365)).strftime("%Y-%m-%dT%H:%M:%SZ")
    
    try:
        response = sess.request("GET", f"https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin={timeMin}&timeMax={timeMax}&singleEvents=true&orderBy=startTime")
        response.raise_for_status()
    except requests.exceptions.HTTPError as e:
        return e
    


    calendar = response.json()["items"]
    for event in calendar:
        try:
            start = event['start']['dateTime'].replace("T", " ")
            end = event['end']['dateTime'].replace("T", " ")
            summary = event['summary']
            id = event['id']
        except TypeError as e:
            print(e)
            return


        query = f"""
        INSERT INTO events (gcalid, title, start, "end", type, userids) VALUES (\'{id}\', \'{summary}\', \'{start}\', \'{end}\', \'gcal\', ARRAY[\'{username}\']);
        """
        cursor.execute(query)

    return JsonResponse({})
