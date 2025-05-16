//
//  ProjectApp.swift
//  Project
//
//  Created by  User on 03.05.2025.
//

import SwiftUI

@main
struct ProjectApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
