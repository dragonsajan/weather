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
    
    @StateObject private var coordinator: MainCoordinator
    
    init() {
        _coordinator = StateObject(wrappedValue: MainCoordinator())
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.home)
                    .navigationDestination(for: Route.self) { route in
                        coordinator.build(route)
                    }
            }
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
