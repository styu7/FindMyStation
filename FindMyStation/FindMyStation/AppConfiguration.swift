//
//  AppConfiguration.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import Foundation

struct AppConfiguration {
    static let searchRadius = 1.0 ///km
    static let stationsRefreshPeriod = 15.0 ///seconds
    static let locationUpdateFilterDistance = 50.0 /// meters
    static let stationsDataUserDefaultsKey = "charging_stations_data"
}
