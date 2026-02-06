//
//  Coordinator.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation
import Combine
import SwiftUI

protocol Coordinator: ObservableObject {
    var path: NavigationPath { get set }
    func push(_ flow: Route)
    func pop()
    func popToRoot()
}
