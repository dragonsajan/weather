//
//  CodeDataService.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//


import CoreData


final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private let context: NSManagedObjectContext
    
    // Required context — avoids default-value isolation issue
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Convenience for main-context usage
    convenience init() {
        self.init(context: PersistenceController.shared.container.viewContext)
    }
    
    // MARK: - Save WeatherData
        func save(weather: WeatherData) {

            // Avoid duplicates
            let request: NSFetchRequest<CDWeather> = CDWeather.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", weather.id as CVarArg)

            let entity = (try? context.fetch(request).first)
                ?? CDWeather(context: context)

            entity.id = weather.id
            entity.city = weather.city
            entity.latitude = weather.latitude
            entity.longitude = weather.longitude
            entity.subtitle = weather.subtitle
            entity.iconName = weather.iconName
            entity.createdAt = Date()

            saveContext()
        }

        // MARK: - Fetch All
        func fetchAllWeatherData() -> [WeatherData] {
            let request: NSFetchRequest<CDWeather> = CDWeather.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: true)
            ]

            do {
                return try context.fetch(request).map {
                    WeatherData(from: $0)
                }
            } catch {
                print("CoreData fetch error:", error)
                return []
            }
        }

        // MARK: - Delete
        func delete(weather: WeatherData) {
            let request: NSFetchRequest<CDWeather> = CDWeather.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", weather.id as CVarArg)

            if let entity = try? context.fetch(request).first {
                context.delete(entity)
                saveContext()
            }
        }

        // MARK: - Save Context
        private func saveContext() {
            guard context.hasChanges else { return }
            try? context.save()
        }
}
