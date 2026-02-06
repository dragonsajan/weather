//
//  AppTopography.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//


import SwiftUI

enum AppTypography {

    static func font(for style: AppTextStyle) -> Font {
        switch style {

        // MARK: - Navigation / Screens
        case .appBarTitle:
            return .largeTitle

        case .screenTitle:
            return .title2

        case .sectionHeader:
            return .title3

        // MARK: - Tiles
        case .tileHeading:
            return .headline

        case .tileSubheading:
            return .subheadline

        case .tileValue:
            return .title2

        // MARK: - General
        case .body:
            return .body

        case .caption:
            return .caption
        }
    }

    static func weight(for style: AppTextStyle) -> Font.Weight {
        switch style {
        case .appBarTitle, .screenTitle, .tileValue:
            return .semibold

        case .tileHeading, .sectionHeader:
            return .medium

        default:
            return .regular
        }
    }
}
