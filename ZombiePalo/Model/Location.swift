//
//  Location.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
// MARK: - Location

class Location: Codable {
    var lat: Double
    var lng: Double

    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
