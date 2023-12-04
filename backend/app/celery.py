from __future__ import absolute_import, unicode_literals
import os

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'sample_app.settings')

app = Celery( 'celery_app',
broker='redis://localhost:6379/0',
backend='redis://localhost:6379/0')

app.autodiscover_tasks()