//
//  WeatherTileView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

struct WeatherTileView: View {

    let weatherData: WeatherData

    var body: some View {
        HStack(spacing: 16) {

            // MARK: - Left (City + Condition)
            VStack(alignment: .leading, spacing: .appXXSmall) {

                Text(weatherData.city)
                    .appTextStyle(.tileHeading)
                    .foregroundColor(.white)

                Text(weatherData.subtitle)
                    .appTextStyle(.tileSubheading)
                    .foregroundColor(.white.opacity(0.7))

                Spacer(minLength: 4)

                AppImageView(
                    url: weatherData.iconURL,
                    content: { image in
                        image
                            .scaledToFit()
                            .frame(width: .appXLarge, height: .appXLarge)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: .appXLarge, height: .appXLarge)
                    }
                )

                Text(weatherData.condition)
                    .appTextStyle(.body)
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()

            // MARK: - Right (Temp + H/L)
            VStack(alignment: .trailing, spacing: .appXXSmall) {

                Text(weatherData.temperature)
                        .font(.system(size: 48, weight: .thin))
                        .foregroundColor(.white)

                HStack(spacing: 8) {
                    Text("H:\(weatherData.high)")
                    Text("L:\(weatherData.low)")
                }
                .appTextStyle(.caption)
                .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, .appMedium)
        .padding(.vertical, .appMedium)
        .frame(maxWidth: .infinity, minHeight: 110, maxHeight: 120)
        .background(tileBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
    }
}
