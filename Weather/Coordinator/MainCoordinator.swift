//
//  MainCoordinator.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//


import SwiftUI
import Combine

@MainActor
final class MainCoordinator: ObservableObject, Coordinator {
    
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func build(_ route: Route) -> some View {
        switch route {
        case .home:
            let viewModel = WeatherHomeViewModel(repository: WeatherRepository(apiService: ApiService()), coordinator: self, coreData: CoreDataService(), locationService: LocationService())
            WeatherHomeView(viewModel: viewModel)
            
        case .weatherDetail(let data):
            WeatherDetailView(weatherData: data)
            
        }
    }
}

