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
        TaskGetAction(parameters: ProfileRequest(userid: AuthStore.shared.getUsername())).call() { response in
            
            for task in response {
                let members = task.users.map {
                    User(username: $0.userid, fname: $0.fname, lname: $0.lname, email: "email@example.com")
                }
                
                var group: varGroup?
                if let group_id = task.group_id {
                    group = varGroup(server_id: group_id, title: "Group", userids: [])
                }

                
                self.save(varTask(
                    id: UUID(),
                    server_id: task.taskid,
                    title: task.title,
                    timeNeeded: task.duration,
                    dueDate: APIConstants.convertStringToDate(task.due_date) ?? Date(),
                    taskDescription: task.description,
                    members: members,
                    scheduled: task.scheduled,
                    group: group
                ), fetching: true)
            }
        }
    }
    
    func generate_events(task_id: UUID, server_id: Int?, preferredTime: String) {
        if let server_id {
            if let index = tasks.firstIndex(where: { $0.server_id == server_id }) { // If the task is in the list, update it
                tasks[index].scheduled = true
                TaskAutoGenerateAction(server_id: server_id, parameters: TaskAutoGenerateRequest(time_preference: preferredTime)).call()
            }
        } else {
            print("Unable to generate events")
        }
    }
    
    func delete(task_id: UUID, server_id: Int?) {
        if let server_id {
            if let index = tasks.firstIndex(where: { $0.server_id == server_id }) { // If the task is in the list, update it
                tasks.remove(at: index)
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
                        taskid: server_id,
                        title: task.title,
                        duration: task.timeNeeded,
                        due_date: ISO8601DateFormatter().string(from: task.dueDate),
                        description: task.taskDescription,
                        userids: [AuthStore.shared.getUsername()],
                        scheduled: task.scheduled,
                        group_id: nil
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
                    userids: [AuthStore.shared.getUsername()],
                    scheduled: task.scheduled,
                    group_id: nil
                )).call() { response in
                    var taskCopy = task
                    taskCopy.server_id = response.id
                    self.tasks.append(taskCopy)
                }
            }
        }
    }
}
