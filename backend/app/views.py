from app.autosched import *
from app.tasks import *
from app.events import *
from app.groups import *
from app.gcal import *
from app.users import *
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import UserStatistics, Insight, Suggestion
import openai

# TASK API CALLS


@require_http_methods(["POST"])
@csrf_exempt
def gettasks(request):
    return gettasksDB(request)


@csrf_exempt
@require_http_methods(["POST"])
def posttask(request):
    return posttasksDB(request)


@csrf_exempt
@require_http_methods(["PUT", "DELETE"])
def editorDeleteTask(request, taskid):
    if request.method == "PUT":
        return edittasksDB(request, taskid)
    else:
        return deletetaskDB(request, taskid)


# GROUP API CALLS
@require_http_methods(["POST"])
@csrf_exempt
def getgroups(request):
    return getgroupsDB(request)


@csrf_exempt
@require_http_methods(["POST"])
def postgroups(request):
    return postgroupsDB(request)


@csrf_exempt
@require_http_methods(["PUT", "DELETE"])
def editOrDeleteGroups(request, groupid):
    if request.method == "PUT":
        return editgroupDB(request, groupid)
    else:
        return deletegroupDB(request, groupid)


# SCHEDULE API CALLS
@csrf_exempt
@require_http_methods(["POST"])
def autoschedule(request, taskid):
    return autoscheduleDB(request, taskid)


@csrf_exempt
@require_http_methods(["POST"])
def postgoogle(request):
    return postgoogleDB(request)

# EVENT/CALENDAR API CALLS


@require_http_methods(["POST"])
@csrf_exempt
def getevents(request):
    return geteventsDB(request)


@csrf_exempt
@require_http_methods(["POST"])
def createevent(request):
    return createeventDB(request)


@csrf_exempt
@require_http_methods(["PUT", "DELETE"])
def editorDeleteEvent(request, eventid):
    return editorDeleteEventDB(request, eventid)


@csrf_exempt
@require_http_methods(["POST"])
def getEventsForTask(request, taskid):
    return getEventsForTaskDB(request, taskid)

# USER AUTHENTICATION CALLS


@csrf_exempt
@require_http_methods(["POST"])
def login(request):
    return loginDB(request)


@csrf_exempt
@require_http_methods(["POST"])
def signup(request):
    return signupDB(request)


@csrf_exempt
@require_http_methods(["POST"])
def getProfileInfo(request):
    return getUserProfileInfoDB(request)

# NLP for user statistics


@api_view(['GET'])
def get_user_statistics(request):
    # Logic to fetch and return user statistics from the database
    user_statistics = {'Instagram': 55,
                       'Focus': 10, 'Snapchat': 20, 'YouTube': 15}
    return Response(user_statistics)


@api_view(['POST'])
def generate_insights(request):
    # Extract user statistics from the request
    user_statistics = request.data.get('user_statistics', {})

    # Use the user statistics to create a prompt for ChatGPT
    insight_prompt = f"Generate an insight based on user statistics: {user_statistics}, the insights will be shown on the Focus app which help the user to focus on tasks"
    suggestion_prompt = f"Generate an suggestion based on user statistics: {user_statistics}, the suggestions need to help the user to focus on tasks rather than using other apps"
    # Call OpenAI API to get insights
    openai.api_key = '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'
    insight_response = openai.Completion.create(
        engine="text-davinci-002",
        prompt=insight_prompt,
        max_tokens=150
    )
    suggestion_response = openai.Completion.create(
        engine="text-davinci-002",
        prompt=suggestion_prompt,
        max_tokens=150
    )

    # Extract insights from the OpenAI API response
    insight = insight_response['choices'][0]['text']
    suggestion = suggestion_response['choices'][0]['text']
    # Save insights to the database
    Insight.objects.create(content=insight)
    Suggestion.objects.create(content=suggestion)

    return JsonResponse({'insight': insight, 'suggestion': suggestion})
