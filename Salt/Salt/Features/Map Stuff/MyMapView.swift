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
    var tint: Color { color ?? .accentColor }
    let id = UUID()
}


struct MyMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @Binding var directions: [String]
    @Binding var eta: [Int]
    @ObservedObject var lm = LocationHelper()
    @ObservedObject var locationString = locationD()
    @Binding var address: String
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: LocationHelper.currentLocation.latitude, longitude: LocationHelper.currentLocation.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        // NYC
        print("Received:", self.address)
        
        let geocoder = CLGeocoder()
        let group = DispatchGroup()
        group.enter()
        geocoder.geocodeAddressString(self.address, completionHandler: { (locations, error) in
            if error == nil {
                if let location = locations?[0] {
                    print("Running")
                    self.locationString.lat = locations?[0].location?.coordinate.latitude ?? 53.1
                    self.locationString.long = locations?[0].location?.coordinate.longitude ?? 42.5
                    print("Done")
                    group.leave()
                    
                }
            } else {
                print("Failed")
                group.leave()
            }
        }
        )
        
        group.notify(queue: .main) {
            print(locationString.lat, " ", locationString.long )
            
            
            let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: LocationHelper.currentLocation.latitude, longitude: LocationHelper.currentLocation.longitude))
            
            // Boston
            let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locationString.lat, longitude: locationString.long))
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: p1)
            request.destination = MKMapItem(placemark: p2)
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotations([p1, p2])
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                    animated: true)
                self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
                
    
                self.eta = [Int(route.expectedTravelTime)]
                print(eta)
                
            }
        }
        return mapView

    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
    
    
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
    
    let locationManager = CLLocationManager()
    
    override init() {
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

class locationD: ObservableObject {
    @Published var name = "Failed"
    @Published var coor = CLLocationCoordinate2D()
    @Published var lat = 0.53
    @Published var long = 0.55
    @Published var time = 0
}
