# CSP auto scheduling for calendar events for individual tasks (not group tasks)

# need to assign a task to a specific time frame
# variables are the user's calendar 
# values is the specific task 
# constraints are the task's timeNeeded, currently available time, must before due date,  

from datetime import datetime, timedelta

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

# test case:
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

open_timeslots = [TimeSlot(datetime(2023, 1, 1, 9, 0), timedelta(hours=2)),
              TimeSlot(datetime(2023, 1, 1, 13, 0), timedelta(hours=1))]

# print(datetime(2023, 1, 1, 9, 0))

tasks = [Task("Task1", timedelta(hours=1), datetime(2023, 1, 1, 14, 0), 2),
         Task("Task2", timedelta(hours=2), datetime(2023, 1, 1, 15, 0), 1)]

solution = schedule_tasks(open_timeslots, tasks)
for key in solution:
    print(key)
    print(solution[key])
print(solution)
