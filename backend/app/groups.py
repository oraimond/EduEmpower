from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def getgroupsDB(request):
    """
    TODO: Ensure that groups returned are for specific user
    """ # similar to tasks, ensure that we search in the table for userid and not all groups !!!!!!


    request_body = json.loads(request.body)
    userid = request_body['userid']

    cursor = connection.cursor()
    cursor.execute(f'''SELECT groupid, title, userids, inviter, invitees FROM groups
                       WHERE inviter = \'{userid}\'
                       OR \'{userid}' = ANY(userids)
                       OR '{userid}' = ANY(invitees);''')  # not sure what fields we wanted
    rows = cursor.fetchall()

    response = []
    for row in rows:
        group = {}
        group['groupid'] = row[0]
        group['title'] = row[1]
        group["userids"] = row[2]
        group["inviter"] = row[3]
        group['invitees'] = row[4]
        response.append(group)

    return JsonResponse(response, safe=False)

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
    # for user in emails:
    #     query = f"""
    #     SELECT userid FROM USERS WHERE email = \'{user}\';
    #     """
    #     #userid = cursor.execute(query) .fetchone()
    #     #invitees.append(userid['userid'])

    #     cursor.execute(query)
    #     userid = cursor.fetchone()
    #     invitees.append(userid[0])
    #     userid = userid[0]
    #     query = f"""
    #         UPDATE users
    #         SET group_invitations = ARRAY_APPEND(group_invitations, userid)
    #         WHERE userid =\'{userid}\';
    #         """
    #     cursor.execute(query)



    cursor.execute(f'INSERT INTO groups (title, inviter, invitees) VALUES '
                   '(%s, %s, %s) RETURNING groupid;', (title, inviter, invitees))

    groupid = cursor.fetchone()[0]
    return JsonResponse({'groupid': groupid, 'title': title, 'userids': invitees})

def editgroupDB(request, groupid):
    """
    TODO: Implement this function
    """ #should be similar to task equivalent 
    if request.method != 'PUT':
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
        #userid = cursor.execute(query).fetchone()
        #invitees.append(userid['userid'])

        cursor.execute(query)
        userid = cursor.fetchone()
        invitees.append(userid[0])
        userid = userid[0]
        query = f"""
            UPDATE users
            SET group_invitations = ARRAY_APPEND(group_invitations, userid)
            WHERE userid =\'{userid}\';
            """
        cursor.execute(query)

    cursor.execute(f'UPDATE groups SET title = %s, inviter = %s, invitees= %s '
                   'WHERE groupid = %s;', (title, inviter, invitees, groupid))


    response = {}
    response['id'] = groupid
    
    return JsonResponse(response)

def deletegroupDB(request, groupid):
    """
    TODO: Implement this function
    """ #should be same as task equivalent 
    if request.method != 'DELETE':
        return HttpResponse(status=404)

    cursor = connection.cursor()
    cursor.execute('DELETE FROM groups WHERE groupid = %s;' (groupid,))

    
    return JsonResponse({"message": "Group successfully deleted", "id": groupid})
