//
//  MockCoordinator.swift
//  WeatherTests
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI
import Combine
@testable import Weather

final class MockCoordinator: Coordinator {

    // MARK: - Published Path (required by protocol)
    @Published var path = NavigationPath()

    // MARK: - Tracking (Assertions)
    private(set) var pushedRoutes: [Route] = []
    private(set) var popCalled = false
    private(set) var popToRootCalled = false

    // MARK: - Protocol Methods
    func push(_ flow: Route) {
        pushedRoutes.append(flow)
    }

    func pop() {
        popCalled = true
    }

    func popToRoot() {
        popToRootCalled = true
    }

    // MARK: - Test Helper
    func reset() {
        path = NavigationPath()
        pushedRoutes.removeAll()
        popCalled = false
        popToRootCalled = false
    }
}
