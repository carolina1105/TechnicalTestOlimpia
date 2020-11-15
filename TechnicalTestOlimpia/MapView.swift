//
//  MapView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private let seconds: Double = 0.5
    
    @Binding var region: MKCoordinateRegion
    @Binding var annotation: MKPointAnnotation
    @Binding var location: LocationModel?
    @Binding var isRemoveAnnotations: Bool
    @State var map: MKMapView = MKMapView()
    var selectLocation: (CLLocation) -> Void
    var didLocation: (LocationModel) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        map.addGestureRecognizer(context.coordinator.locationGesture())
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        map.setRegion(region, animated: true)
        if let location = location {
            map.removeAnnotations(map.annotations)
            map.addAnnotation(location)
            map.selectAnnotation(location, animated: true)
        } else {
            map.addAnnotation(annotation as MKAnnotation)
        }
        if isRemoveAnnotations {
            map.removeAnnotations(map.annotations)
        }
    }

    func makeCoordinator() -> MapDelegate {
        return MapDelegate(map: $map,
                           location: $location,
                           selectLocation,
                           didLocation)
    }
}

class MapDelegate: NSObject, MKMapViewDelegate {
    private let annotationId: String = "annotation"
    private let sendSize: CGFloat = 30
    
    @Binding var map: MKMapView
    @Binding var location: LocationModel?
    var selectLocation: (CLLocation) -> Void
    var didLocation: (LocationModel) -> Void
    
    init(map: Binding<MKMapView>,
         location: Binding<LocationModel?>,
         _ selectLocation: @escaping (CLLocation) -> Void,
         _ didLocation: @escaping (LocationModel) -> Void) {
        _map = map
        _location = location
        self.selectLocation = selectLocation
        self.didLocation = didLocation
    }
    
    func locationGesture() -> UIGestureRecognizer {
        let location = UILongPressGestureRecognizer(target: self,
                                                    action: #selector(addLocation))
        return location
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
    
        let pin = MKPinAnnotationView(annotation: annotation,
                                      reuseIdentifier: annotationId)
        pin.tintColor = UIColor.red
        pin.animatesDrop = annotation is MKPointAnnotation
        pin.rightCalloutAccessoryView = sendLocation()
        pin.canShowCallout = true
        return pin
    }
    
    func sendLocation() -> UIButton {
        let symbol = UIImage.SymbolConfiguration(pointSize: sendSize,
                                                 weight: .regular)
        let icon = UIImage(systemName: "paperplane.fill",
                           withConfiguration: symbol)?.withRenderingMode(.alwaysTemplate)
            .rotate(radians: 0.7853)
        let button = UIButton(frame: CGRect(x: .zero,
                                             y: .zero,
                                            width: sendSize,
                                            height: sendSize))
        button.setImage(icon, for: .normal)
        button.tintColor = UIColor.red
        return button
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let location = location {
            didLocation(location)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userPin = views.first(where: { $0.annotation is MKUserLocation }) {
            userPin.canShowCallout = false
        }
    }
}

extension MapDelegate {
    @objc func addLocation(_ gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: map)
            let coordinates = map.convert(point, toCoordinateFrom: map)
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            selectLocation(location)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(region: .constant(MKCoordinateRegion()),
                annotation: .constant(MKPointAnnotation()),
                location: .constant(nil),
                isRemoveAnnotations: .constant(false),
                selectLocation: { _ in

        }) { _ in
        }
    }
}
