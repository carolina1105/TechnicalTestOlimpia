//
//  LocationViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    private let sendHeight = CGFloat(44.0)
    private let seconds: Double = 0.1
    private let two: Double = 2
    private let alertTypeOne: Int = 1
    private let alertTypeTwo: Int = 2
    private let cancelNormalWidth: CGFloat = 80
    private let distance: CLLocationDistance = 600
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var localSearch: MKLocalSearch? = nil
    private let searchTermKey = "SearchTermKey"
    private var searchTimer: Timer?
    
    @Published var locations: [LocationModel] = []
    @Published var location: LocationModel? {
        didSet {
            withAnimation {
                guard let address = location?.title else {
                    return
                }
                self.isLocation = true
                self.address = address
            }
        }
    }
    @Published var isLocation: Bool = false {
        didSet {
            if isLocation {
                bottomLocation = sendHeight
            } else {
                bottomLocation = .zero
            }
        }
    }
    @Published var address: String = ""
    @Published var isRemoveAnnotations: Bool = false
    @Published var showAlert: Bool = false
    @Published var failMessage: String = ""
    @Published var alertType: Int = .zero
    @Published var searching: Bool = false
    @Published var search: String = "" {
        didSet {
            withAnimation {
                searching = !search.isEmpty
                cancelWidth = !search.isEmpty ? cancelNormalWidth : .zero
            }
            searchResult()
        }
    }
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var annotation: MKPointAnnotation = MKPointAnnotation()
    @Published var cancelWidth: CGFloat = .zero
    @Published var bottomLocation: CGFloat = .zero
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func authorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            self.alertType = alertTypeOne
            self.showAlert = true
            self.failMessage = "TEXT_PERMISSION_LOCATION_DESC".localized
        default:
            break
        }
    }
    
    func showCurrentLocation(_ authIfNecessary: Bool = true) {
        if authIfNecessary { authorization() }
        locationManager.startUpdatingLocation()
    }
    
    func showCoordinates(_ coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        let metersOffset = distance
        region = MKCoordinateRegion(center: coordinate, latitudinalMeters: metersOffset, longitudinalMeters: metersOffset)
    }
    
    func selectLocation(location: CLLocation) {
        annotation.coordinate = location.coordinate
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location) { response, error in
            let error = error as NSError?
            let geocodeCanceled = error?.domain == kCLErrorDomain && error?.code == CLError.Code.geocodeCanceled.rawValue
            
            if let error = error, !geocodeCanceled {
                self.alertType = self.alertTypeTwo
                self.showAlert = true
                self.failMessage = error.localizedDescription
                self.location = nil
                self.isRemoveAnnotations = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.seconds) {
                    self.isRemoveAnnotations = false
                }
            } else if let placemark = response?.first {
                let name = placemark.areasOfInterest?.first
                self.location = LocationModel(name: name, location: location, placemark: placemark)
            }
        }
    }
    
    func clean() {
        searchTimer?.invalidate()
        searchTimer = nil
        localSearch?.cancel()
        geocoder.cancelGeocode()
    }
    
    deinit {
        clean()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let shouldAnimate = self.location != nil
        showCoordinates(location.coordinate, animated: shouldAnimate)
        selectLocation(location: location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        showCurrentLocation()
    }
}

extension LocationViewModel {
    func searchResult() {
        show(items: nil)
        
        let term = search.trimmingCharacters(in: .whitespaces)
        if !term.isEmpty {
            searchTimer = WeakTimer.scheduledTimer(timeInterval: seconds,
                                                   target: self,
                                                   userInfo: [searchTermKey : term],
                                                   repeats: false) { [weak self] timer in
                                                    guard let strongSelf = self else { return }
                                                    strongSelf.searchFromTimer(timer)
            }
        } else {
            searchTimer?.invalidate()
            searchTimer = nil
        }
    }
    
    func searchFromTimer(_ timer: Timer) {
        guard let userInfo = timer.userInfo as? [String: AnyObject],
            let term = userInfo[searchTermKey] as? String else {
                return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = term
        
        if let location = locationManager.location {
            let latlongDelta: CLLocationDegrees = two

            request.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: latlongDelta,
                                       longitudeDelta: latlongDelta)
            )
        }
        
        localSearch?.cancel()
        localSearch = MKLocalSearch(request: request)
        localSearch?.start { [weak self] response, _ in
            guard let strongSelf = self else { return }
            strongSelf.show(items: response)
        }
    }
    
    func show(items results: MKLocalSearch.Response?) {
        locations = results?.mapItems.map {
        LocationModel(name: $0.name,
                      placemark: $0.placemark)
        } ?? []
    }
}
