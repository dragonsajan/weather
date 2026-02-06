//
//  AppTextModifier+Extension.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

extension View {
    func appTextStyle(_ style: AppTextStyle) -> some View {
        self.modifier(AppTextModifier(style: style))
    }
}
