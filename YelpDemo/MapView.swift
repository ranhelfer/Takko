//
//  MapView.swift
//  YelpDemo
//
//  Created by rhalfer on 25/01/2021.
//

import SwiftUI
import MapKit

struct MapView: View {

    @ObservedObject var locationManager = LocationManager()
    
    /* You use the @State attribute to establish a source of truth for data in your app that you can modify from more than one view. SwiftUI manages the underlying storage and automatically updates views that depend on the value. */
    @State private var region = MKCoordinateRegion()

    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
            Text("location status: \(locationManager.statusString)")
            HStack {
                Text("latitude: \(region.center.latitude)")
                Text("longitude: \(region.center.latitude)")
            }
        }.onReceive(self.locationManager.objectWillChange, perform: { _ in
            region = setRegion()
        })
    }
    
    private func setRegion() -> MKCoordinateRegion {
        let coordinate = CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
        return MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
