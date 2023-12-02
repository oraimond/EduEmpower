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

    request_body = json.loads(request.body)
    userid = request_body['userid']

    cursor = connection.cursor()
    cursor.execute(f'''SELECT groupid, title, userids, inviter, invitees FROM groups
                       WHERE inviter = \'{userid}\'
                       OR \'{userid}' = ANY(userids)
                       OR '{userid}' = ANY(invitees);''')  # not sure what fields we wanted
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
    title = json_data['title']
    inviter = json_data['inviter']
    emails = json_data['invitees']
    cursor = connection.cursor()
    invitees = []
    for user in emails:
        query = f"""
        SELECT userid FROM USERS WHERE email = \'{user}\';
        """
        userid = cursor.execute(query).fetchone()
        invitees.append(userid['userid'])

        query = f"""
            UPDATE users
            SET groups_invitations = ARRAY_APPEND(group_invitations, userid['userid'])
            WHERE userid =\'{userid['userid']}\';
            """
        cursor.execute(query)



    cursor.execute(f'INSERT INTO groups (title, inviter, invitees) VALUES '
                   '(%s, %s, ARRAY[%s]);', (title, inviter, invitees))

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
