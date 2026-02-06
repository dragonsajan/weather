//
//  WeatherListView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

struct WeatherListView: View {

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
