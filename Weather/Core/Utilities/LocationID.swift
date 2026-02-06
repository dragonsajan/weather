//
//  LocationID.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import Foundation

import Foundation
import CryptoKit

enum LocationID {

    /// Generates a stable UUID from latitude & longitude
    static func from(latitude: Double, longitude: Double) -> UUID {
        let normalized = "\(round(latitude * 10_000) / 10_000)-\(round(longitude * 10_000) / 10_000)"
        let hash = SHA256.hash(data: Data(normalized.utf8))
        let uuidBytes = Array(hash.prefix(16))

        return UUID(uuid: (
            uuidBytes[0], uuidBytes[1], uuidBytes[2], uuidBytes[3],
            uuidBytes[4], uuidBytes[5], uuidBytes[6], uuidBytes[7],
            uuidBytes[8], uuidBytes[9], uuidBytes[10], uuidBytes[11],
            uuidBytes[12], uuidBytes[13], uuidBytes[14], uuidBytes[15]
        ))
    }
}
