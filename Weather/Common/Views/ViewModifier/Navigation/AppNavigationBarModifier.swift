//
//  NavigationBarModifier.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

struct AppNavigationBarModifier: ViewModifier {

    let title: String
    let displayMode: NavigationBarItem.TitleDisplayMode
    let trailingButton: NavigationBarButton

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(displayMode)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    trailingButton.view
                }
            }
    }
}
