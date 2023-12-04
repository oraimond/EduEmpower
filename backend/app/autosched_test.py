# this file doesn't actually do anything for the app, just to mess around with the CSP alg.
# actual backend autoscheduling things are located in 'autosched.py'

from datetime import datetime, timedelta

def autoscheduleDB(taskid, task_userids, task_duration, task_due_date, rows, time_preference): # rows means events rows from the database which i will hard code for testing 
    # if request.method != 'POST':
    #     return HttpResponse(status=404)
    
    # # TODO: call calendar update function 
    
    # # get tasks from database 
    # cursor = connection.cursor()
    # cursor.execute('SELECT title, duration, due_date, description, userids, group_id, scheduled, taskid FROM tasks WHERE taskid = %s;', (taskid))
    # rows = cursor.fetchall()

    # if len(rows) != 8:
    #     print('The resulting query from the Tasks table has one or more missing attributes.')
    #     return HttpResponse("CUSTOM MESSAGE", status=500, headers={"CUSTOM MESSAGE": "Result of query from Tasks table has missing attributes."})

    # task_title = rows[0]
    # task_duration = rows[1]
    # task_due_date = rows[2]
    # task_description = rows[3]
    # task_userids = rows[4]
    # task_group_id = rows[5]
    # task_scheduled = rows[6]

    # if rows[7] != taskid:
    #     print('TaskID from front end does not match TaskID retreived from database.')
    #     return HttpResponse("CUSTOM MESSAGE", status=500, headers={"CUSTOM MESSAGE": "TaskID from front end does not match TaskID retreived from database."})
    
    # if task_scheduled == True:
    #     print('The given TaskID has already been scheduled.')
    #     return HttpResponse("CUSTOM MESSAGE", status=500, headers={"CUSTOM MESSAGE": "The given TaskID has already been scheduled."})

    # # get calendar events from database 
    # cursor1 = connection.cursor()
    # cursor1.execute('SELECT title, start, end, type, users, taskid, eventid FROM events WHERE start < %s ORDER BY start ASC;', (task_due_date))
    # rows = cursor1.fetchall()

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
        if task_duration > timeslot[1] - timeslot[0]:
            continue

        if task_due_date < timeslot[0]:
            continue

        viable_timeslots.append(timeslot)

    def timeslot_duration(timeslot_interval):
        return timeslot_interval[1] - timeslot_interval[0]
    
    viable_timeslots = sorted(viable_timeslots, key=timeslot_duration, reverse=True)

    # # TODO: stuff for the user preferences of work time for auto schedule task 
    # time_preference = request.POST.get("time_preference")

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

    return final_timeslot

    # else:
    #     print('Invalid value for time preference.')
    #     return HttpResponse("CUSTOM MESSAGE", status=500, headers={"CUSTOM MESSAGE": "Invalid value for time preference."})



    # # add new event to the events database table 
    # cursor = connection.cursor()
    # cursor.execute('INSERT INTO events (title, start, end, type, users, taskid) VALUES '
    #                '(%s, %s, %s, %s, %s, %s, %s);', (task_title, final_timeslot, final_timeslot + task_duration, 'automatedTask', task_userids, taskid))
    

    # response = {}
    # response['task_to_timeslot'] = [taskid, viable_timeslots[0][0], viable_timeslots[0][1]]
    # return JsonResponse(response)


# taskid, task_userids, task_duration, task_due_date, rows, time_preference
taskid = "Task0001"
task_userids = [1,2,3]
task_duration = timedelta(hours=2)
task_due_date = datetime(2023, 12, 1)
# 'SELECT title, start, end, type, users, taskid, eventid FROM events WHERE start < %s ORDER BY start ASC;'
rows = [('title', datetime(2023, 11, 30, 12), datetime(2023, 11, 30, 14), 'type', [1], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 30, 13), datetime(2023, 11, 30, 16), 'type', [2], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 30, 17), datetime(2023, 11, 30, 20), 'type', [3], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 29, 7), datetime(2023, 11, 29, 10), 'type', [1,2], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 29, 13), datetime(2023, 11, 29, 14), 'type', [2,3], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 28, 19), datetime(2023, 11, 28, 22), 'type', [1,3], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 28, 21), datetime(2023, 11, 28, 23), 'type', [1,2,3], "Task0001", 'eventid'),
        ('title', datetime(2023, 11, 28, 21), datetime(2023, 11, 28, 23), 'type', [4], "Task0001", 'eventid')
        ]
time_preference = 'afternoon'

test_result = autoscheduleDB(taskid, task_userids, task_duration, task_due_date, rows, time_preference)
print(test_result)









# def schedule_tasks(open_timeslots, tasks):
#     domains = {}
#     for slot in open_timeslots:
#         domains[slot] = tasks.copy()

#     constraints = [
#         lambda task, slot: task_length_fits(task, slot),
#         lambda task, slot: task_scheduled_before_due_date(task, slot),
#     ]

#     return backtrack_search(open_timeslots, domains, constraints)

# def task_length_fits(task, slot):
#     return task.duration <= slot.duration

# def task_scheduled_before_due_date(task, slot):
#     return task.due_date >= slot.start_time

# def backtrack_search(open_timeslots, domains, constraints):
#     return backtrack({}, open_timeslots, domains, constraints)

# def backtrack(assignment, open_timeslots, domains, constraints):
#     if is_complete(assignment, open_timeslots):
#         return assignment  # Solution found

#     slot = select_unassigned_variable(assignment, open_timeslots)
#     for task in order_domain_values(slot, assignment, open_timeslots, domains, constraints):
#         if is_consistent(task, slot, assignment, constraints):
#             assignment[slot] = task
#             result = backtrack(assignment, open_timeslots, domains, constraints)
#             if result is not None:
#                 return result
#             del assignment[slot]  # Backtrack

#     return None  # No solution found

# def is_complete(assignment, open_timeslots):
#     return set(assignment.keys()) == set(open_timeslots)

# def select_unassigned_variable(assignment, open_timeslots):
#     unassigned = set(open_timeslots) - set(assignment.keys())
#     return min(unassigned, key=lambda slot: slot.start_time)

# def order_domain_values(slot, assignment, open_timeslots, domains, constraints):
#     return sorted(domains[slot], key=lambda task: task.priority, reverse=True)

# def is_consistent(task, slot, assignment, constraints):
#     for constraint in constraints:
#         if not constraint(task, slot):
#             return False
#     return True

# # test case:
# class Task:
#     def __init__(self, name, duration, due_date, priority):
#         self.name = name
#         self.duration = duration
#         self.due_date = due_date
#         self.priority = priority

# class TimeSlot:
#     def __init__(self, start_time, duration):
#         self.start_time = start_time
#         self.duration = duration

# open_timeslots = [TimeSlot(datetime(2023, 1, 1, 9, 0), timedelta(hours=2)),
#               TimeSlot(datetime(2023, 1, 1, 13, 0), timedelta(hours=1))]

# # print(datetime(2023, 1, 1, 9, 0))

# tasks = [Task("Task1", timedelta(hours=1), datetime(2023, 1, 1, 14, 0), 2),
#          Task("Task2", timedelta(hours=2), datetime(2023, 1, 1, 15, 0), 1)]

# solution = schedule_tasks(open_timeslots, tasks)
# for key in solution:
#     print(key)
#     print(solution[key])
# print(solution)
