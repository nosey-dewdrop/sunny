//
//  sunnyApp.swift
//  sunny
//
//  Created by Damla Bilge on 17.03.2026.
//

import SwiftUI

@main
struct sunnyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
