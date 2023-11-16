from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
from google_auth_oauthlib.flow import Flow
from datetime import datetime
from datetime import timedelta
import requests

def postgoogleDB(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    scopes = ['https://www.googleapis.com/auth/calendar', 'https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/calendar.events', 'openid']
    CLIENT_SECRET_FILE = "app/client_secret.json"
    
    flow = Flow.from_client_secrets_file(CLIENT_SECRET_FILE, scopes)
    flow.redirect_uri = ""
    
    request_content = json.loads(request.body)

    auth_code = request_content['auth_code']


    flow.fetch_token(code=auth_code)


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
    return JsonResponse({})
