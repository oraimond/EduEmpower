//
//  TaskStore.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/15/23.
//

import Foundation

class TaskStore: ObservableObject {
    static let shared = TaskStore()
    
    @Published var tasks = [varTask]()
    
    private init() {}
    
    func fetchTasks() {
        TaskGetAction().call() { response in
            
            for task in response {
                let members = task.assigned_users.map {
                    User(id: $0.user_id, fname: $0.fname, lname: $0.lname)
                }
                print(task.title)
                print(task.id)

                
                self.save(varTask(
                    id: UUID(),
                    server_id: task.id,
                    title: task.title,
                    timeNeeded: task.duration,
                    dueDate: DateFormatter().date(from: task.due_date) ?? Date(),
                    taskDescription: task.description,
                    members: members,
                    scheduled: task.scheduled
                    //group: varGroup?
                ), fetching: true)
            }
        }
    }
    
    func generate_events(task_id: UUID, server_id: Int?) {
        if let index = tasks.firstIndex(where: { $0.id == task_id }) { // If the task is in the list, update it
            tasks[index].scheduled = true
            if let server_id {
                TaskAutoGenerateAction(server_id: server_id).call()
            }
        } else {
            print("Unable to generate events")
        }
    }
    
    func delete(task_id: UUID, server_id: Int?) {
        if let index = tasks.firstIndex(where: { $0.id == task_id }) { // If the task is in the list, update it
            tasks.remove(at: index)
            if let server_id {
                TaskDeleteAction(server_id: server_id).call()
            }
        } else {
            print("Unable to delete task")
        }
    }
    
    func save(_ task: varTask, fetching: Bool = false) {
        if fetching {
            // Getting task from server
            if let index = tasks.firstIndex(where: { $0.server_id == task.server_id }) { // If the task is in the list, update it
                tasks[index] = task
            } else {
                tasks.append(task)
            }
        } else {
            // Getting task from user app input
            if let index = tasks.firstIndex(where: { $0.id == task.id }) { // If the task is in the list, update it
                if let server_id = task.server_id {
                    TaskPutAction(parameters: TaskPutRequest(
                        id: server_id,
                        title: task.title,
                        duration: task.timeNeeded,
                        due_date: ISO8601DateFormatter().string(from: task.dueDate),
                        description: task.taskDescription,
                        assigned_users: [], //TODO
                        scheduled: task.scheduled,
                        group_id: nil //TODO
                    )).call() { response in
                        if response.id == server_id {
                            self.tasks[index] = task
                        }
                    }
                } else {
                    print("Error updating task")
                }
                
                
            } else { // If the task is not in the list, add it
                print(ISO8601DateFormatter().string(from: task.dueDate))
                print(task.dueDate)
                TaskPostAction(parameters: TaskPostRequest(
                    title: task.title,
                    duration: task.timeNeeded,
                    due_date: ISO8601DateFormatter().string(from: task.dueDate),
                    description: task.taskDescription,
                    assigned_users: [], //TODO
                    scheduled: task.scheduled,
                    group_id: nil //TODO
                )).call() { response in
                    var taskCopy = task
                    taskCopy.server_id = response.id
                    self.tasks.append(taskCopy)
                }
            }
        }
    }
}
