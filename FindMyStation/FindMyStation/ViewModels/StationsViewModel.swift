//
//  StationsViewModel.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import Combine
import Foundation
import CoreLocation

protocol StationsViewModelProtocol {
    var stationsData: StationsData? { get }
    var stationsDataPublisher: Published<StationsData?>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
}

class StationsViewModel: StationsViewModelProtocol {
    @Published var stationsData: StationsData? = nil
    @Published var isLoading: Bool = false
    
    var stationsDataPublisher: Published<StationsData?>.Publisher { $stationsData }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }

    private let locationManager = LocationService()
    private let userDefaults = UserDefaults.standard
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private var currentLocation: CLLocationCoordinate2D?
    
    init() {
        stationsData = retrieveFromUserDefaults()
        self.locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self else { return }
                
                self.currentLocation = location.coordinate
                self.fetch()
                self.startTimerRefresh()
            }
            .store(in: &cancellables)
    }
    
    @objc private func fetch() {
        isLoading = true
        
        StationsService()
            .execute(location: currentLocation!) { [weak self] response in
                guard let self = self else {
                    return
                }
                self.isLoading = false
                
                guard let response = response else {
                    return
                }
                self.stationsData = StationsData(from: response, lastUpdateTime: DateFormatter.dateNowString)
                saveToUserDefaults()
            }
    }
    
    // MARK: - Caching
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(stationsData) {
            userDefaults.set(encoded, forKey: AppConfiguration.stationsDataUserDefaultsKey)
        }
    }
    
    private func retrieveFromUserDefaults() -> StationsData? {
        if let data = userDefaults.object(forKey: AppConfiguration.stationsDataUserDefaultsKey) as? Data,
           let decodedData = try? JSONDecoder().decode(StationsData.self, from: data) {
            return decodedData
        } else {
            return nil
        }
    }
    
    // MARK: - Timer
    
    private func startTimerRefresh() {
        /// invalidate previous timer if it exists, to avoid extra requests when location is changed
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(
            timeInterval: AppConfiguration.stationsRefreshPeriod,
            target: self,
            selector: #selector(StationsViewModel.fetch),
            userInfo: nil,
            repeats: true
        )
    }
}

// MARK: - Helpers

private extension DateFormatter {
    static var dateNowString: String {
        let format = DateFormatter()
        format.timeStyle = .medium
        format.dateStyle = .medium
        return format.string(from: Date())
    }
}
