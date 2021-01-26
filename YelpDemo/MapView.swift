//
//  MapView.swift
//  YelpDemo
//
//  Created by rhalfer on 25/01/2021.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MapView: View {

    @ObservedObject var locationManager = LocationManager()

    /* You use the @State attribute to establish a source of truth for data in your app that you can modify from more than one view. SwiftUI manages the underlying storage and automatically updates views that depend on the value. */
    @State private var region = MKCoordinateRegion()
    @State private var businesses = [BusinessModel]()
    
    private var currentSpan = 0.07
    @State private var annotationItems = [AnnotationItem]()
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: annotationItems) { item  in
                MapPin(coordinate: item.coordinate)
            }
            HStack {
                if region.center.latitude != 0 &&  region.center.longitude != 0 {
                    Text("latitude: \(region.center.latitude)")
                    Text("longitude: \(region.center.longitude)")
                } else {
                    Text("Loading location...")
                }
            }.foregroundColor(.green)
            List {
                ForEach(self.businesses) { business in
                    Text(business.name ?? "")
                }
            }
            
            Spacer()
        }.onReceive(self.locationManager.objectWillChange, perform: { _ in
            handleOnRecieveEvent()
        })
    }
    
    private func handleOnRecieveEvent() {
        guard shouldSetRegion() else {
            return
        }
        
        setRegion()
        
        let service = YelpRequestService()
        
        if let serviceRequestBusinesses = service.request(latitude: CGFloat(region.center.latitude), longitude: CGFloat(region.center.longitude)) {
            self.businesses = serviceRequestBusinesses
            
            for business in self.businesses {
                if let coordinate = business.coordinates?.coordinates() {
                    self.annotationItems.append(AnnotationItem(coordinate: coordinate))
                }
            }
        }
    }
    private func locationManagerCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    private func shouldSetRegion() -> Bool {
        let newCoordinate = locationManagerCoordinate()
        if region.center.latitude == newCoordinate.latitude &&
            region.center.longitude == newCoordinate.longitude  {
            return false
        }
        return true
    }
    
    private func setRegion() {
        /*  This line specifically is causing
            runtime: SwiftUI: Modifying state during view update, this will cause undefined behavior. */
        region = MKCoordinateRegion(
                    center: locationManagerCoordinate(),
                    span: MKCoordinateSpan(latitudeDelta: currentSpan, longitudeDelta: currentSpan))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MapView()
        }
    }
}
