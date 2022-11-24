//
//  AnnouncerApp.swift
//  Announcer
//
//  Created by John Sextro on 11/24/22.
//

import SwiftUI

@main
struct AnnouncerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
