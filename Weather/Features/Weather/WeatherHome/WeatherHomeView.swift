//
//  WeatherHomeView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

struct WeatherHomeView: View {

    @StateObject var viewModel: WeatherHomeViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            content
                .appNavigationBar(
                    title: "Weather",
                    trailingButton: .more(action: {})
                )
                
        }
        .loadingOverlay(
            isLoading: $viewModel.isLoading,
            message: "Loading weather…"
        )
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                viewModel.validateAndLoadWeather()
            }
        }
        .alert(
            "Location Permission Needed",
            isPresented: $viewModel.showLocationPermissionAlert
        ) {
            Button("Open Settings") {
                viewModel.openAppSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
            viewModel.validateAndLoadWeather()
        }
    }
}

// Made extension as it helps to get viewmode and action easily,
// Else need to pass multiple value
extension WeatherHomeView {
    
    var content: some View {
        ZStack {
            GradientView()
            VStack(spacing: 12) {
                SearchBarView(placeholder: "Search city") {
                    viewModel.openSearch()
                }
                .sheet(isPresented: $viewModel.isSearchPresented) {
                    WeatherSearchView { city in
                        Task {
                                    await viewModel.addCity(city)
                                }
                    }
                }
                
               WeatherListView(
                   weatherList: viewModel.weatherList,
                   action: viewModel.handle
               )
           }
        }
    }
}

