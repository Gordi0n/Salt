//
//  adtocoor.swift
//  Salt
//
//  Created by Gordon Gooi on 25/12/21.
//

import SwiftUI
import MapKit

struct adtocoor: View {
    @State var location: CLLocationCoordinate2D?
    @StateObject private var locationString = locationD()

    var body: some View {
        Text(locationString.name)
            .onAppear {
                self.getLocation(from: locationString.name) { coordinates in
                    print(locationString)
                    print(coordinates ?? 1234) // Print here
                    self.location = coordinates // Assign to a local variable for further processing
                }
        }
        
        

    }
       
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
}
