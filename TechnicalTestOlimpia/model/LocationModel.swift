//
//  LocationModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit
import MapKit

class LocationModel: NSObject, Identifiable {
    private let two: CGFloat = 2
    private let meter: CLLocationDistance = 300
    private let size: CGFloat = 256
    public let id: UUID = UUID()
    public let name: String?

    public let location: CLLocation
    public let placemark: CLPlacemark

    public var address: String? {
        guard let addressDictionary = placemark.addressDictionary,
            let lines = addressDictionary["FormattedAddressLines"] as? [String] else { return nil }
        return lines.joined(separator: ", ")
    }

    public var urlString: String {
        return "https://maps.google.com/maps?q=\(coordinate.latitude)%2C\(coordinate.longitude)"
    }

    enum LocationError: Error {
        case assertion
    }

    public func generateSnapshot(didShapshot: @escaping (UIImage) -> Void) {
        let options = MKMapSnapshotter.Options()
        let metersOffset: CLLocationDistance = meter

        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: metersOffset, longitudinalMeters: metersOffset)

        options.size = CGSize(width: size, height: size)

        MKMapSnapshotter(options: options).start(with: .global()) { snapshot, error in
            guard error == nil else {
                print("Unexpectedly failed to capture map snapshot \(error!)")
                return
            }

            guard let snapshot = snapshot else {
                print("snapshot unexpectedly nil")
                return
            }

            UIGraphicsBeginImageContextWithOptions(options.size, true, .zero)
            snapshot.image.draw(at: .zero)

            let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            pinView.pinTintColor = UIColor.tint
            let pinImage = pinView.image

            var point = snapshot.point(for: self.coordinate)

            let pinCenterOffset = pinView.centerOffset
            point.x -= pinView.bounds.size.width / self.two
            point.y -= pinView.bounds.size.height / self.two
            point.x += pinCenterOffset.x
            point.y += pinCenterOffset.y
            pinImage?.draw(at: point)

            let image = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()

            guard let finalImage = image else {
                print("image unexpectedly nil")
                return
            }

            didShapshot(finalImage)
        }
    }

    public init(name: String?, location: CLLocation? = nil, placemark: CLPlacemark) {
        self.name = name
        self.location = location ?? placemark.location!
        self.placemark = placemark
    }

    public var messageText: String {
        if let address = address {
            return address + "\n\n" + urlString
        } else {
            return urlString
        }
    }
}

extension LocationModel: MKAnnotation {
    @objc public var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }

    public var title: String? {
        if let name = name {
            return name
        } else if let addressDictionary = placemark.addressDictionary,
            let lines = addressDictionary["FormattedAddressLines"] as? [String],
            let firstLine = lines.first {
            return firstLine
        } else {
            return "\(coordinate.latitude), \(coordinate.longitude)"
        }
    }
}
