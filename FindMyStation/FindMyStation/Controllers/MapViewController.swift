//
//  MapViewController.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import UIKit
import MapKit
import CoreLocation
import Combine

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewModel: StationsViewModelProtocol
    
    // MARK: - Initialization

    init?(coder: NSCoder, viewModel: StationsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a viewModel.")
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        bindViewModel()
    }
    
    // MARK: - ViewModel binding
    
    func bindViewModel() {
        viewModel.stationsDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self = self, let stations = data?.stations else {
                    return
                }
                self.setupAnnotations(with: stations)
            }
            .store(in: &cancellables)
        }
    
    // MARK: - Map setup
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func setupAnnotations(with stations: [Station]) {
        for station in stations {
            let annotation = MKPointAnnotation()
            annotation.title = station.id
            annotation.coordinate = CLLocationCoordinate2D(latitude: station.coordinates.latitude,
                                                           longitude: station.coordinates.longitude)
            self.mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "StationPin"
        
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let color = viewModel.stationsData?.stations.first(where: {$0.id == annotation.title})?.iconColor
            annotationView?.markerTintColor = color
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

