//
//  AppTextModifier.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

struct AppTextModifier: ViewModifier {

    let style: AppTextStyle

    func body(content: Content) -> some View {
        content
            .font(AppTypography.font(for: style))
            .fontWeight(AppTypography.weight(for: style))
    }
}

