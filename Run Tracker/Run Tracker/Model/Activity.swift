//
//  Activity.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/20/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import Foundation

class Activity: Codable {
    var type: String
    var duration: String
    var distance: Double
    var distance_unit: String
    
    init(Type: String, Duration: String, Distance: Double, DistanceUnit: String) {
        self.type = Type
        self.duration = Duration
        self.distance = Distance
        self.distance_unit = DistanceUnit
    }
}
