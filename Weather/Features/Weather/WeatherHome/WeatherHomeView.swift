//
//  WeatherHomeView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

struct WeatherHomeView: View {
    
    @StateObject var viewModel: WeatherHomeViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                MainView(weatherList: viewModel.weatherList, onDelete: viewModel.delete)
            }
            .appNavigationBar(title: "Weather",  trailingButton: .more(action: {}))
        }
        .task {
            await viewModel.fetchWeatherDataForLocation()
        }
    }
}

// Main View
fileprivate struct MainView: View {

    let weatherList: [WeatherData]
    let onDelete: (WeatherData) -> Void

    var body: some View {
        WeatherListView(
            weatherList: weatherList,
            onDelete: onDelete
        )
        .padding(.top, .appXLarge)
    }
}


fileprivate struct WeatherListView: View {

    let weatherList: [WeatherData]
    let onDelete: (WeatherData) -> Void

    var body: some View {
        List {
            ForEach(weatherList) { weather in
                WeatherTileView(weatherData: weather)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            onDelete(weather)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    WeatherHomeView(
        viewModel: WeatherHomeViewModel(repository: WeatherRepository(apiService: ApiService()))
    )
}

