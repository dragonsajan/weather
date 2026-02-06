//
//  WeatherSearchBarView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

struct SearchBarView: View {

    let placeholder: String
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            Text(placeholder)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 2)
        .contentShape(Rectangle())
        .padding(.leading,20)
        .padding(.trailing,20)
        .onTapGesture {
            onTap()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityIdentifier("search_button")
    }
}
