//
//  WeatherDetailView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

struct WeatherDetailView: View {

    let weatherData: WeatherData

    var body: some View {
        ScrollView {
            VStack(spacing: .appLarge) {

                HeaderSection(weatherData: weatherData)
                TemperatureSection(weatherData: weatherData)
                ConditionSection(weatherData: weatherData)
                HighLowSection(weatherData: weatherData)
            }
            .padding(.appLarge)
        }
        .background(GradientView(colorList: [Color.cyan.opacity(0.5),Color.blue, Color.blue.opacity(0.6), ]))
        .navigationTitle(weatherData.city)
        .navigationBarTitleDisplayMode(.inline)
    }
}


private struct HeaderSection: View {
    let weatherData: WeatherData
    
    var body: some View {
        VStack(spacing: .appXXSmall) {

            Text(weatherData.city)
                .appTextStyle(.screenTitle)
                .foregroundColor(.white)

            Text(weatherData.subtitle)
                .appTextStyle(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}


private struct TemperatureSection: View {
    
    let weatherData: WeatherData
    
    var body: some View {
        VStack(spacing: .appMedium) {

            AppImageView(
                url: weatherData.iconURL,
                content: { image in
                    image
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                },
                placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            )

            Text(weatherData.temperature)
                .font(.system(size: 72, weight: .thin))
                .foregroundColor(.white)
        }
    }
}

private struct ConditionSection: View {
    
    let weatherData: WeatherData

    var body: some View {
        Text(weatherData.condition)
            .appTextStyle(.sectionHeader)
            .foregroundColor(.white.opacity(0.9))
    }
}


private struct HighLowSection: View {
    
    let weatherData: WeatherData

    var body: some View {
        HStack(spacing: .appLarge) {

            valueCard(title: "High", value: weatherData.high)
            valueCard(title: "Low", value: weatherData.low)
        }
    }

    func valueCard(title: String, value: String) -> some View {
        VStack(spacing: .appXXSmall) {

            Text(title)
                .appTextStyle(.caption)
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .appTextStyle(.tileValue)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.appMedium)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

