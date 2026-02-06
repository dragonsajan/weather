//
//  NavigationBarButton.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

enum NavigationBarButton {

    case more(size: AppSize = .medium, action: () -> Void)
    case search(size: AppSize = .medium, action: () -> Void)
    case none

    @ViewBuilder
    var view: some View {
        switch self {
        case .more(let size, let action):
            button(systemImage: "gearshape.fill", size: size, action: action)

        case .search(let size, let action):
            button(systemImage: "magnifyingglass", size: size, action: action)

        case .none:
            EmptyView()
        }
    }

//    private func button(systemImage: String, size: AppSize, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Image(systemName: systemImage)
//                .frame(
//                    width: AppDimensions.Button.size(size),
//                    height: AppDimensions.Button.size(size)
//                )
//                .contentShape(Rectangle())
//        }
//    }
    
    private func button(systemImage: String, size: AppSize, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .frame(width: 44, height: 44) // common touch target size
                .background(Circle().fill(.gray.opacity(0.18)))
        }
        .buttonStyle(.plain)
    }
}
