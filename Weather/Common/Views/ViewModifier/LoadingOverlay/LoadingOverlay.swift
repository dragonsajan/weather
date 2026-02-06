//
//  Loading.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

struct LoadingOverlayModifier: ViewModifier {

    @Binding var isLoading: Bool
    let message: String?

    func body(content: Content) -> some View {
        ZStack {
            content

            if isLoading {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    // Loader container
                    VStack(spacing: 16) {
                        ProgressView()
                            .controlSize(.large)
                            .scaleEffect(1.2)

                        if let message {
                            Text(message)
                                .appTextStyle(.tileHeading)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.appLarge)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
