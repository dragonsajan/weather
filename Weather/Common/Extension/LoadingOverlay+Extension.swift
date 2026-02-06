//
//  LoadingOverlay+Extension.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

extension View {
    func loadingOverlay(
        isLoading: Binding<Bool>,
        message: String? = nil
    ) -> some View {
        self.modifier(
            LoadingOverlayModifier(
                isLoading: isLoading,
                message: message
            )
        )
    }
}
