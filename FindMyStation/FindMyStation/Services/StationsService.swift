//
//  GetStationsRequest.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import CoreLocation

struct StationsService {
    
    func execute(location: CLLocationCoordinate2D, completion: @escaping (StationsResponse?) -> Void) {
        let boxCoordinates = StationsService.calculateGeoBox(for: location, radius: AppConfiguration.searchRadius)
        let urlString = "http://ich-tanke-strom.switzerlandnorth.cloudapp.azure.com:8080/geoserver/ich-tanke-strom/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=ich-tanke-strom%3Aevse&maxFeatures=50&outputFormat=application%2Fjson&cql_filter=bbox(geometry,\(boxCoordinates.topLeft.longitude),\(boxCoordinates.topLeft.latitude),\(boxCoordinates.bottomRight.longitude),\(boxCoordinates.bottomRight.latitude))"

           guard let url = URL(string: urlString) else {
               return
           }

           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if error != nil {
                   completion(nil)
                   return
               }

               guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                   print("Error with the response, unexpected status code: \(String(describing: response))")
                   return
               }
               
               if let data = data, let response = StationsResponse.decode(from: data) {
                   completion(response)
               }
           }
        task.resume()
    }
}

private extension StationsService {
    
    static func calculateGeoBox(for coordinates: CLLocationCoordinate2D, radius: Double) -> (topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {

        let earthRadiusKm: Double = 6371.0
        
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude

        // Calculate offsets in degrees
        let dLat = radius / earthRadiusKm * (180 / .pi)  // 1 km in latitude degrees
        let dLon = radius / (earthRadiusKm * cos(latitude * .pi / 180)) * (180 / .pi)  // 1 km in longitude degrees

        // Calculate square points
        let topLeft = CLLocationCoordinate2D(latitude: latitude + dLat, longitude: longitude - dLon)
        let bottomRight = CLLocationCoordinate2D(latitude: latitude - dLat, longitude: longitude + dLon)

        return (topLeft: topLeft, bottomRight: bottomRight)
    }
}
