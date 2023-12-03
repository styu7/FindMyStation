//
//  ChargingStationResponse.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import Foundation

struct StationsResponse: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let properties: Properties
    let geometry: Geometry
}

struct Properties: Codable {
    let id: String
    let availability: String
    let chargingFacilities: [ChargingFacility]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case availability = "EvseStatus"
        case chargingFacilities = "ChargingFacilities"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.availability = try container.decode(String.self, forKey: .availability)
        self.chargingFacilities = try container.decode([ChargingFacility].self, forKey: .chargingFacilities)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(availability, forKey: .availability)
        try container.encode(chargingFacilities, forKey: .chargingFacilities)
    }
}

struct Geometry: Codable {
    let coordinates: [Double]
}

struct ChargingFacility: Codable {
    let power: Float
    
    enum CodingKeys: String, CodingKey {
        case power = "Power"
    }
}

extension StationsResponse {
    static func decode(from data: Data) -> StationsResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(StationsResponse.self, from: data)
            return response
        } catch {
            print("Error parsing JSON data: \(error)")
            return nil
        }
    }
}
