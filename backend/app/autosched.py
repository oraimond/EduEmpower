from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json


from datetime import datetime, timedelta

class Task:
    def __init__(self, name, duration, due_date, priority):
        self.name = name
        self.duration = duration
        self.due_date = due_date
        self.priority = priority

class TimeSlot:
    def __init__(self, start_time, duration):
        self.start_time = start_time
        self.duration = duration

def schedule_tasks(open_timeslots, tasks):
    domains = {}
    for slot in open_timeslots:
        domains[slot] = tasks.copy()

    constraints = [
        lambda task, slot: task_length_fits(task, slot),
        lambda task, slot: task_scheduled_before_due_date(task, slot),
    ]

    return backtrack_search(open_timeslots, domains, constraints)

def task_length_fits(task, slot):
    return task.duration <= slot.duration

def task_scheduled_before_due_date(task, slot):
    return task.due_date >= slot.start_time

def backtrack_search(open_timeslots, domains, constraints):
    return backtrack({}, open_timeslots, domains, constraints)

def backtrack(assignment, open_timeslots, domains, constraints):
    if is_complete(assignment, open_timeslots):
        return assignment  # Solution found

    slot = select_unassigned_variable(assignment, open_timeslots)
    for task in order_domain_values(slot, assignment, open_timeslots, domains, constraints):
        if is_consistent(task, slot, assignment, constraints):
            assignment[slot] = task
            result = backtrack(assignment, open_timeslots, domains, constraints)
            if result is not None:
                return result
            del assignment[slot]  # Backtrack

    return None  # No solution found

def is_complete(assignment, open_timeslots):
    return set(assignment.keys()) == set(open_timeslots)

def select_unassigned_variable(assignment, open_timeslots):
    unassigned = set(open_timeslots) - set(assignment.keys())
    return min(unassigned, key=lambda slot: slot.start_time)

def order_domain_values(slot, assignment, open_timeslots, domains, constraints):
    return sorted(domains[slot], key=lambda task: task.priority, reverse=True)

def is_consistent(task, slot, assignment, constraints):
    for constraint in constraints:
        if not constraint(task, slot):
            return False
    return True





def autoschedule(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    
    # get tasks from database 
    cursor = connection.cursor()
    cursor.execute('SELECT taskid, tasktitle, timeneeded, duedate FROM events;')
    rows = cursor.fetchall()

    tasks = []
    for row in rows:
        tasks.append(Task(row[0], timedelta(hours=row[2]), datetime(row[3])))

    # get time slots from database 
    cursor1 = connection.cursor()
    cursor1.execute('SELECT eventid, start, end FROM calendar ORDER BY start ASC;')
    rows = cursor1.fetchall()

    for row1, row2 in zip(rows, rows[1:]):
        eventid_1 = row1[0]
        start_1 = row1[1]
        end_1 = row1[2]

        eventid_2 = row2[0]
        start_2 = row2[1]
        end_2 = row2[2]

        row1[1] = end_1 # start time of open timeslot 
        row1[2] = start_2 - end_1 # duration of open timeslot

    if rows:
        lastrow = rows.pop()

    open_timeslots = []
    for row in rows:
        open_timeslots.append(TimeSlot(datetime(row[1])), row1[2])

    # call backtracking search 
    solution = schedule_tasks(open_timeslots, tasks)

    results = []
    for timeslot in solution:
        task = solution[timeslot]

        timeslot_start = timeslot.start_time
        timeslot_duration = timeslot.duration

        task_title = task.name
        task_duration = task.duration
        task_duedate = task.due_date

        results.append((timeslot_start, timeslot_duration, task_title, task_duration, task_duedate))


    response = {}
    response['task_to_timeslot'] = results
    return JsonResponse(response)




    

# test case:


# open_timeslots = [TimeSlot(datetime(2023, 1, 1, 9, 0), timedelta(hours=2)),
#               TimeSlot(datetime(2023, 1, 1, 13, 0), timedelta(hours=1))]

# # print(datetime(2023, 1, 1, 9, 0))

# tasks = [Task("Task1", timedelta(hours=1), datetime(2023, 1, 1, 14, 0), 2),
#          Task("Task2", timedelta(hours=2), datetime(2023, 1, 1, 15, 0), 1)]

# solution = schedule_tasks(open_timeslots, tasks)
# for key in solution:
#     print(key, solution[key])
# print(solution)
