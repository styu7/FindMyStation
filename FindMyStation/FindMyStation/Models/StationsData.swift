//
//  StationsData.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import Foundation
import UIKit

struct StationsData: Codable {
    let stations: [Station]
    let lastUpdateTime: String
    
    init(from response: StationsResponse, lastUpdateTime: String) {
        self.stations = response.features
            .compactMap { feature in
                if let latitude = feature.geometry.coordinates.last,
                   let longitude = feature.geometry.coordinates.first {
                    
                    return Station(
                        id: feature.properties.id,
                        availability: feature.properties.availability,
                        coordinates: Coordinates(latitude: latitude,
                                                 longitude: longitude),
                        /// Using only the biggest value of power from received array of available powers of chargers
                        power: feature.properties.chargingFacilities
                            .map { $0.power }
                            .sorted(by: >).first ?? 0.0
                    )
                } else {
                    return nil
                }
            }
            .sorted(by: { $0.power > $1.power })
        
        self.lastUpdateTime = lastUpdateTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stations, forKey: .stations)
        try container.encode(lastUpdateTime, forKey: .lastUpdateTime)
    }
}

struct Station: Codable {
    let id: String
    let availability: String
    let coordinates: Coordinates
    let power: Float
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

extension Station {
    enum Availabity: String {
        case available = "Available"
        case occupied = "Occupied"
        case outOfService = "OutOfService"
    }
    
    var iconName: String {
        let value = Availabity(rawValue: availability) ?? .outOfService
        switch value {
        case .available:
            return "face.smiling.fill"
        case .occupied:
            return "hourglass.tophalf.fill"
        case .outOfService:
            return "exclamationmark.circle"
        }
    }
    
    var iconColor: UIColor {
        let value = Availabity(rawValue: availability) ?? .outOfService
        switch value {
        case .available:
            return .green
        case .occupied:
            return .yellow
        case .outOfService:
            return .red
        }
    }
}

