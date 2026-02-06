//
//  CityRowView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

struct CityRowView: View {
    
    let city: CityData
    
    var body: some View {
        VStack(alignment: .leading, spacing: .appXSmall) {
            Text(city.name)
                .appTextStyle(.tileHeading)
            Text(city.displayName)
                .appTextStyle(.tileSubheading)
        }
        .padding(.vertical, .appXXSmall)
    }
}
