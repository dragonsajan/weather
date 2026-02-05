//
//  WeatherApp.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI
import CoreData

@main
struct WeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
