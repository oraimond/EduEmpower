from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
from google.oauth2 import id_token
from google.auth.transport import requests

import hashlib, time


def loginDB(request):
    """
    TODO: Implement this
    """
    return JsonResponse({})

def signupDB(request):
    """
    TODO: Implement this - copied and changed from signin lab, can probably delete the expiration stuff
    """

    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    clientID = json_data['clientID']   # the front end app's OAuth 2.0 Client ID
    idToken = json_data['idToken']     # user's OpenID ID Token, a JSon Web Token (JWT)

    now = time.time()                  # secs since epoch (1/1/70, 00:00:00 UTC)

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

    # get password and everything else - NOT SURE WHAT TO PUT in IDINFOR '' !!!!!!!!!!
    try:
        password = idinfo['password']
        fname = idinfo['fname']
        lname = = idinfo['lname']
        email = idinfo['email']
    except:
        password = "Profile NA"
        fname = "Profile NA"
        lname = "Profile NA"
        email = "Profile NA"

    # Compute userid and add to database
    backendSecret = "callmeishmael"   # or server's private key MIGHT NEED To CHANGE THIS !!!!!!!!!
    nonce = str(now)
    hashable = idToken + backendSecret + nonce
    userid = hashlib.sha256(hashable.strip().encode('utf-8')).hexdigest()

    # Lifetime of userid is minimum of time to idToken expiration and
    # target lifetime, which should be less than idToken lifetime (~1 hour). 
    # (int()+1 == ceil()) 
    lifetime = min(int(idinfo['exp']-now)+1, 60) # secs, up to idToken's lifetime

    cursor = connection.cursor()
    # clean up db table of expired chatterIDs
    cursor.execute('DELETE FROM users WHERE %s > expiration;', (now, ))

    # insert new userid
    # Ok for userid to expire about 1 sec beyond idToken expiration
    cursor.execute('INSERT INTO users (password, fname, lname, email, userid) VALUES '
                   '(%s, %s, %s);', (password, fname, lname, email, userid))

    # Return userid etc
    return JsonResponse({'userid': userid, 'first_name': fname, 'last_name': lname, 'email': email})
    
    # return JsonResponse({})

def getUserProfileInfoDB(request):
    """
    TODO: Implement this
    """
    return JsonResponse({})
