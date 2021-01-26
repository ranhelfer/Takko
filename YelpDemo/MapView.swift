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
            Map(coordinateRegion: $region).frame(height: 300, alignment: .top)
            HStack {
                if region.center.latitude != 0 &&  region.center.longitude != 0 {
                    Text("latitude: \(region.center.latitude)")
                    Text("longitude: \(region.center.longitude)")
                } else {
                    Text("Loading location...")
                }
            }
            
            Spacer()
        }.onReceive(self.locationManager.objectWillChange, perform: { object in
            handleOnRecieveEvent()
        })
    }
    
    private func handleOnRecieveEvent() {
        region = setRegion()
        
        let service = YelpRequestService()
        service.request(latitude: CGFloat(region.center.latitude), longitude: CGFloat(region.center.longitude))
    }
    
    private func setRegion() -> MKCoordinateRegion {
        let coordinate = CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
        return MKCoordinateRegion(
                center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MapView()
        }
    }
}
