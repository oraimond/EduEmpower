"""
URL configuration for routing project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views, autosched, tasks

urlpatterns = [
    path('admin/', admin.site.urls),
    path('tasks/', views.gettasks, name='gettasks'),
    path('task/', views.posttask, name='posttask'),
    path('events/', views.getevents, name='getevents'),
    path('groups/', views.getgroups, name='getgroups'),
    path('group/', views.postgroups, name='postgroups'),
    path('task/<str:taskid>/generate_events/',
         views.autoschedule, name='autoschedule'),
    path('postgoogle/', views.postgoogle, name='postgoogle'),
    path('task/<str:taskid>', views.editorDeleteTask, name='updatetask'),
    path('group/<str:groupid>', views.editOrDeleteGroups, name='editOrDelete'),
    path('event', views.createevent, name='createevent'),
    path('event/<str:eventid>', views.editorDeleteEvent, name='editOrDeleteEvents'),
    path('task/<str:taskid>/event/',
         views.getEventsForTask, name='getEventsForTask'),
    path('/login', views.login, name='login'),
    path('/signup', views.signup, name='signup'),
    path('/user/profile', views.getProfileInfo, name='getProfileInfo'),
    path('user-statistics/', views.get_user_statistics,
         name='get_user_statistics'),
    path('generate-insights/', views.generate_insights, name='generate_insights'),
]
