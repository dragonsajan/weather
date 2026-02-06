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
                MainView(weathers: viewModel.weatherList)
            }
            .appNavigationBar(title: "Weather",  trailingButton: .more(action: {}))
        }
    }
}


fileprivate struct MainView: View {
    
    let weathers: [Weather]
    
    var body: some View {
        VStack(spacing: .appMedium) {
            WeatherListView(weathers: weathers)
            Spacer()
        }
        .padding(.top, .appXLarge)
    }
}

fileprivate struct WeatherListView: View {
    
    let weathers: [Weather]

    var body: some View {
        ScrollView {
            LazyVStack(
                spacing: .appMedium
            ) {
                ForEach(weathers) { weather in
                    WeatherTileView(weather: weather)
                }
            }
            .padding(.horizontal, .appMedium)
        }
    }
}

#Preview {
    WeatherHomeView(
        viewModel: WeatherHomeViewModel()
    )
}

