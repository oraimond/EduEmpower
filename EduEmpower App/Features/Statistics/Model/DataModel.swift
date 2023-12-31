//
//  DataModel.swift
//  EduEmpower App
//
//  Created by Sori Kang on 12/3/23.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

private let _DataModel = DataModel()

class DataModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    class var shared: DataModel {
        return _DataModel
    }
    
    func setShieldRestrictions() {
        let applications = DataModel.shared.selectionToDiscourage
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    }
}
