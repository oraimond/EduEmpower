from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.core.exceptions import ValidationError
from django.views.decorators.csrf import csrf_exempt
import json
import uuid
from google.oauth2 import id_token
from google.auth.transport import requests
from django.utils.crypto import get_random_string

import hashlib, time


def loginDB(request):
    """
    TODO: Implement this
    """
    json_data = json.loads(request.body)
    
    username = json_data['userid']
    password = json_data['password']

    cursor = connection.cursor()

    data = cursor.execute(
        f'''SELECT password FROM users WHERE userid = \'{username}\''''
    )
    user = data.fetchone()

    if not user:
        raise ValidationError

    index1 = user['password'].find('$')
    index2 = user['password'].rfind('$')
    salt = user['password'][index1 + 1:index2]
    # print(user)
    if not user or user['password'] != hash_password(password, salt):
        raise ValidationError

    request.session['userid'] = username

    unique_token = get_random_string(length=10)

    now = time.time()

    expires_at = now + 60

    #cursor.execute('INSERT INTO users (refresh_token, expiresat) VALUES '
                   #'(%s, %s) WHERE userid = (%s);', (unique_token, expires_at, username))

    return JsonResponse({'Token': unique_token, 'userid': username, 'expiresat': expires_at})

def signupDB(request):
    """
    TODO: Implement this - copied and changed from signin lab, can probably delete the expiration stuff
    """

    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)


    now = time.time()                  # secs since epoch (1/1/70, 00:00:00 UTC)

    fname = json_data['fname']
    lname = json_data['lname']
    userid = json_data['userid']
    password = json_data['password']
    email = json_data['email']


    # Compute userid and add to database
    backendSecret = "callmeishmael"   # or server's private key MIGHT NEED To CHANGE THIS !!!!!!!!!
    nonce = str(now)
    password = hash_password(password, 'false')

    # Lifetime of userid is minimum of time to idToken expiration and
    # target lifetime, which should be less than idToken lifetime (~1 hour). 
    # (int()+1 == ceil())

    cursor = connection.cursor()
    # clean up db table of expired chatterIDs MIGHT IMPLEMENT THIS LATER
    #cursor.execute('DELETE FROM users WHERE %s > expiration;', (now, ))

    # insert new userid
    # Ok for userid to expire about 1 sec beyond idToken expiration
    cursor.execute('INSERT INTO users (password, fname, lname, email, userid) VALUES '
                   '(%s, %s, %s, %s, %s);', (password, fname, lname, email, userid))
    request.session['userid'] = userid
    # Return userid etc
    return JsonResponse({'userid': userid, 'first_name': fname, 'last_name': lname, 'email': email})
    
    # return JsonResponse({})

def getUserProfileInfoDB(request):
    """
    TODO: Implement this
    """
    json_data = json.loads(request.body)

    user_id = json_data['userid']

    cursor = connection.cursor()
    cursor.execute('SELECT userid, first_name, last_name, email FROM users WHERE (%s) = userid;', (user_id,))
    rows = cursor.fetchall()

    response = {}
    response['user'] = rows
    
    return JsonResponse({response})


def hash_password(password, saltvar):
    """Make a docstring."""
    algorithm = 'sha512'
    if saltvar == 'false':
        salt = uuid.uuid4().hex
    else:
        salt = saltvar
    hash_obj = hashlib.new(algorithm)
    password_salted = salt + password
    hash_obj.update(password_salted.encode('utf-8'))
    password_hash = hash_obj.hexdigest()
    password_db_string = "$".join([algorithm, salt, password_hash])
    return password_db_string
