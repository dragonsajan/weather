//
//  AppDimension.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

import SwiftUI

enum AppDimensions {

    
    enum AppBarButton {
        static func height(_ size: AppSize) -> CGFloat {
            switch size {
            case .xxSmall: return 40
            case .xSmall:  return 44
            case .small:   return 48
            case .medium:  return 52
            case .large:   return 56
            case .xLarge:  return 60
            }
        }
    }
    
    enum FontSize {
        static func height(_ size: AppSize) -> CGFloat {
            switch size {
            case .xxSmall: return 40
            case .xSmall:  return 44
            case .small:   return 48
            case .medium:  return 52
            case .large:   return 56
            case .xLarge:  return 60
            }
        }
    }

    enum Button {
        static func size(_ size: AppSize) -> CGFloat {
            switch size {
            case .xxSmall: return 28
            case .xSmall:  return 32
            case .small:   return 36
            case .medium:  return 44
            case .large:   return 52
            case .xLarge:  return 60
            }
        }
    }

    enum Icon {
        static func size(_ size: AppSize) -> CGFloat {
            switch size {
            case .xxSmall: return 12
            case .xSmall:  return 16
            case .small:   return 20
            case .medium:  return 24
            case .large:   return 28
            case .xLarge:  return 32
            }
        }
    }

    enum Padding {
        static func value(_ size: AppSize) -> CGFloat {
            switch size {
            case .xxSmall: return 4
            case .xSmall:  return 8
            case .small:   return 12
            case .medium:  return 16
            case .large:   return 20
            case .xLarge:  return 24
            }
        }
    }
}


