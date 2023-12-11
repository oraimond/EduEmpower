from django.db import models

# Create your models here.

class UserStatistics(models.Model):
    Focus = models.IntegerField()
    Instagram = models.IntegerField()
    Snapchat = models.IntegerField()
    Youtube = models.IntegerField()

class Insight(models.Model):
    content = models.TextField()

class Suggestion(models.Model):
    content = models.TextField()