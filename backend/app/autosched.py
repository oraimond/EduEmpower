from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json


from datetime import datetime, timedelta
import app.gcal

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




def autoscheduleDB(request, taskid):
    if request.method != 'POST':
        return HttpResponse(status=404)
    

    
    # get tasks from database 
    cursor = connection.cursor()
    cursor.execute('SELECT title, duration, due_date, description, userids, group_id, scheduled, taskid FROM tasks WHERE taskid = %s;', [taskid])
    rows = cursor.fetchall()

    # if len(rows) < 5:
    #     print('The resulting query from the Tasks table has one or more missing attributes.')
    #     return HttpResponse("error1", status=500, headers={"error1": "Result of query from Tasks table has missing attributes (less than 5 attributes)."})

    query_result = rows[0]

    task_title = query_result[0]
    task_duration = query_result[1]
    task_due_date = query_result[2]
    task_description = query_result[3]
    task_userids = query_result[4]
    task_group_id = query_result[5]
    task_scheduled = query_result[6]

    task_due_year = str(task_due_date.year)
    task_due_month = task_due_date.month
    task_due_day = task_due_date.day

    if task_due_month < 10:
        task_due_month = '0' + str(task_due_month)
    else:
        task_due_month = str(task_due_month)

    if task_due_day < 10:
        task_due_day = '0' + str(task_due_day)
    else: 
        task_due_day = str(task_due_day)

    task_due_date_string = task_due_year + '-' + task_due_month + '-' + task_due_day
    today_date = datetime.today()

    # if query_result[-1] != str(taskid):
    #     print('TaskID from front end does not match TaskID retreived from database.')
    #     return HttpResponse("error2", status=500, headers={"error2": "TaskID from front end does not match TaskID retreived from database."})
    
    if task_scheduled == True:
        print('The given TaskID has already been scheduled.')
        return HttpResponse("error3", status=500, headers={"error3": "The given TaskID has already been scheduled."})

    # TODO: call calendar update function
    for user in task_userids:
        app.gcal.updateCalendar(user)

    # get calendar events from database 
    cursor1 = connection.cursor()
    cursor1.execute('SELECT title, eventstart, eventend, type, userids, taskid, eventid FROM events WHERE eventstart < %s ORDER BY eventstart ASC;', [task_due_date_string])
    rows = cursor1.fetchall()

    if len(rows) == 0:
         # add new event to the events database table 
        start_string = str(today_date.year) + '-' + str(today_date.month) + '-' + str(today_date.day)
        end_string = str(today_date.year) + '-' + str(today_date.month) + '-' + str(today_date.day) + ' ' + str(task_duration) + ':00:00'
        cursor = connection.cursor()

        cursor.execute("INSERT INTO events (title, eventstart, eventend, type, userids, taskid) VALUES (%s, %s, %s, %s, %s, %s);", [task_title, start_string, end_string, 'automatedTask', task_userids, taskid])
       
        response = {
            "message": "Events generation for task started",
            "taskid": str(taskid)
        }
        # response['taskid'] = "{" + str(taskid) + "}"
        return JsonResponse(response)

    # only get events that contain users who are included in the given TaskID
    relevant_events = []
    for row in rows: 
        event_users = row[4]

        for userid in task_userids:
            if userid in event_users:
                relevant_events.append(row)
                break

    relevant_events = sorted(relevant_events, key=lambda x: x[1])

    # merge overlapping events into a single time intervals "merged_event_intervals[]"
    event_intervals = []
    for event in relevant_events:
        event_intervals.append((event[1], event[2]))

    merged_event_intervals = [event_intervals[0]]

    for current_interval in event_intervals[1:]:
        previous_interval = merged_event_intervals[-1]

        if current_interval[0] <= previous_interval[1]:
            merged_event_intervals[-1] = (previous_interval[0], max(previous_interval[1], current_interval[1]))
       
        else:
            merged_event_intervals.append(current_interval)

    del event_intervals
    del relevant_events
    del rows

    # get open time slots "open_timeslots[]"
    open_timeslots = []
    for i in range(len(merged_event_intervals) - 1):
        current_interval_end = merged_event_intervals[i][1]
        next_interval_start = merged_event_intervals[i + 1][0]

        interval_between = (current_interval_end, next_interval_start)
        open_timeslots.append(interval_between)

    # add something to prevent time slots from going into 11pm to 8am

    viable_timeslots = []
    for timeslot in open_timeslots:
        # print((timeslot[1] - timeslot[0]))
        if timedelta(hours=task_duration) > timeslot[1] - timeslot[0]:
            continue

        if task_due_date < timeslot[0]:
            continue

        viable_timeslots.append(timeslot)

    def timeslot_duration(timeslot_interval):
        return timeslot_interval[1] - timeslot_interval[0]
    
    viable_timeslots = sorted(viable_timeslots, key=timeslot_duration, reverse=True)

    # # TODO: stuff for the user preferences of work time for auto schedule task 
    time_preference = request.POST.get("time_preference")

    final_timeslot = viable_timeslots[0][0]
    if time_preference == "morning":
        for timeslot in viable_timeslots:
            # TODO: find preferred time slot 
            if (timeslot[0] + task_duration).hour < 12 and (timeslot[0]).hour > 7:
                final_timeslot = timeslot
                break

    elif time_preference == "afternoon":
        for timeslot in viable_timeslots:
            # TODO: find preferred time slot 
            if (timeslot[0]).hour >= 12 and (timeslot[0] + task_duration).hour < 18:
                final_timeslot = timeslot
                break

    elif time_preference == "evening":
        for timeslot in viable_timeslots:
            # TODO: find preferred time slot 
            if (timeslot[0]).hour >= 18 and (timeslot[0] + task_duration).hour < 22:
                final_timeslot = timeslot
                break

    # add new event to the events database table 
    cursor = connection.cursor()
    cursor.execute("INSERT INTO events (title, eventstart, eventend, type, userids, taskid) VALUES (%s, %s, %s, %s, %s, %s);", [task_title, final_timeslot.strftime("%Y-%m-%d %H:%M:%S"), (final_timeslot + timedelta(hours=task_duration)).strftime("%Y-%m-%d %H:%M:%S"), 'automatedTask', task_userids, taskid])
    

    response = {
        "message": "Events generation for task started",
        "taskid": str(taskid)
    }
    return JsonResponse(response)
        





    


# def autoschedule_old(request):
#     if request.method != 'GET':
#         return HttpResponse(status=404)
    
#     # get tasks from database 
#     cursor = connection.cursor()
#     cursor.execute('SELECT taskid, tasktitle, timeneeded, duedate FROM tasks;')
#     rows = cursor.fetchall()

#     tasks = []
#     for row in rows:
#         tasks.append(Task(row[0], timedelta(hours=row[2]), datetime(row[3])))

#     # get time slots from database 
#     cursor1 = connection.cursor()
#     cursor1.execute('SELECT eventid, starttime, endtime FROM events ORDER BY starttime ASC;')
#     rows = cursor1.fetchall()

#     for row1, row2 in zip(rows, rows[1:]):
#         eventid_1 = row1[0]
#         start_1 = row1[1]
#         end_1 = row1[2]

#         eventid_2 = row2[0]
#         start_2 = row2[1]
#         end_2 = row2[2]

#         row1[1] = end_1 # start time of open timeslot 
#         row1[2] = start_2 - end_1 # duration of open timeslot

#     if rows:
#         lastrow = rows.pop()

#     open_timeslots = []
#     for row in rows:
#         open_timeslots.append(TimeSlot(datetime(row[1])), row1[2])

#     # call backtracking search 
#     solution = schedule_tasks(open_timeslots, tasks)

#     results = []
#     for timeslot in solution:
#         task = solution[timeslot]

#         timeslot_start = timeslot.start_time
#         timeslot_duration = timeslot.duration

#         task_title = task.name
#         task_duration = task.duration
#         task_duedate = task.due_date

#         results.append((timeslot_start, timeslot_duration, task_title, task_duration, task_duedate))


#     # put scheduled tasks into events table 
#     cursor = connection.cursor()

#     for result in results:
#         eventtype = "EventType"
#         endtime = timeslot_start + timeslot_duration
#         starttime = timeslot_start
#         note = "temp note"
#         eventid = 0
        
#         cursor.execute('INSERT INTO events (eventtype, endtime, starttime, note, eventid) VALUES '
#                     '(%s %s %s %s %s);', (eventtype, endtime, starttime, note, eventid))


#     response = {}
#     response['task_to_timeslot'] = results
#     return JsonResponse(response)


    

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
