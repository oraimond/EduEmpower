//
//  ScheduleModel.swift
//  EduEmpower App
//
//  Created by Sori Kang on 12/2/23.
//

import Foundation
import DeviceActivity

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

let schedule = DeviceActivitySchedule(
    intervalStart: DateComponents(hour: 0, minute: 0),
    intervalEnd: DateComponents(hour: 23, minute: 59),
    repeats: true
)

class ScheduleModel {
    static public func setSchedule() {
        print("Setting up the schedule")
        print("Current time is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)

        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: DataModel.shared.selectionToEncourage.applicationTokens,
                threshold: DateComponents(minute: 5)
            )
        ]
        
        let center = DeviceActivityCenter()
        do {
            print("Started Monitoring")
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error occured while started monitoring: ", error)
        }
    }
}
