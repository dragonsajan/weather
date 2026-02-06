//
//  WeatherTileView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

struct WeatherTileView: View {

    let weather: Weather

    var body: some View {
        HStack(spacing: .appMedium) {

            // MARK: - Weather Icon
            Image(systemName: weather.icon)
                .font(.system(size: .appLarge))
                .frame(
                    width: .appXLarge,
                    height: .appXLarge
                )
                .foregroundColor(.white)

            // MARK: - City & Condition
            VStack(alignment: .leading, spacing: .appXXSmall) {

                Text(weather.city)
                    .appTextStyle(.tileHeading)
                    .foregroundColor(.white)

                Text(weather.condition)
                    .appTextStyle(.tileSubheading)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            // MARK: - Temperature
            Text("\(Int(weather.temperature))°")
                .appTextStyle(.tileValue)
                .foregroundColor(.white)
        }
        .padding(.appMedium)
        .background(tileBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
    }
}
