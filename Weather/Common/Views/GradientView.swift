//
//  GradientView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI


/// GradientView : A SwiftUI view that displays a vertical linear gradient.
///
/// View returns gradient view with colorList:[Color] parameter
/// By default [Color.blue.opacity(0.9), Color.blue.opacity(0.6), Color.cyan.opacity(0.5)] gradient
///
/// You can customize the gradient by providing a color array
struct GradientView: View {

    let colorList: [Color]

    init(colorList: [Color] = [.blue.opacity(0.9), .blue.opacity(0.6), .cyan.opacity(0.5)]) {
        self.colorList = colorList
    }

    var body: some View {
        LinearGradient(
            colors: colorList,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

