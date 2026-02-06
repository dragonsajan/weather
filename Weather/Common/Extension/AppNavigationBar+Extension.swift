//
//  AppNavigationBar.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

extension View {
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: Navigation Title
    ///   - displayMode: For size of text, default automatic
    ///   - trailingButton: NavigationBar Button
    /// - Returns: <#description#>
    func appNavigationBar(
        title: String,
        displayMode: NavigationBarItem.TitleDisplayMode = .automatic,
        trailingButton: NavigationBarButton
    ) -> some View {
        self.modifier(
            AppNavigationBarModifier(
                title: title,
                displayMode: displayMode,
                trailingButton: trailingButton
            )
        )
    }
}

