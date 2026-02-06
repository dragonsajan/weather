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
            WeatherListView(
                weatherList: viewModel.weatherList,
                action: viewModel.handle
            )
        }
    }
}


fileprivate struct WeatherListView: View {

    // Data
    let weatherList: [WeatherData]

    // Action dispatcher: this will let viewmodel know what to do with single call
    let action: (WeatherHomeAction) -> Void
    

    var body: some View {
        List {
            ForEach(weatherList) { weather in
                WeatherTileView(weatherData: weather)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        action(.navigate(weather))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            action(.delete(weather))
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
}

