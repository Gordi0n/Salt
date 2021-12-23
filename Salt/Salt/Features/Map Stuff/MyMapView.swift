//
//  MyMapView.swift
//  Salt
//
//  Created by Gordon Gooi on 21/12/21.
//

import MapKit
import SwiftUI
import RealmSwift

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    var color: Color?
        var tint: Color { color ?? .red }
    let id = UUID()
}


struct MyMapView: UIViewRepresentable {
  typealias UIViewType = MKMapView
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()

    let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: LocationHelper.currentLocation.latitude, longitude: LocationHelper.currentLocation.longitude),
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    mapView.setRegion(region, animated: true)
      mapView.showsUserLocation = true
      mapView.showsScale = true
      

    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {}
}

import CoreLocation

class LocationHelper: NSObject, ObservableObject {

    static let shared = LocationHelper()
    static let DefaultLocation = CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)

    static var currentLocation: CLLocationCoordinate2D {
        guard let location = shared.locationManager.location else {
            return DefaultLocation
        }
        return location.coordinate
    }

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager changed the status: \(status)")
    }
}
