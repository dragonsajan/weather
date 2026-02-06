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
                WeatherListView(weatherList: viewModel.weatherList,
                                                   action: viewModel.handle)
            }
            .appNavigationBar(title: "Weather",  trailingButton: .more(action: {}))
        }
        .task {
            await viewModel.fetchWeatherDataForLocation()
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


