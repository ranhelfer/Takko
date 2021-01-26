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
    @State private var annotationItems = [AnnotationItem]()
    
    private var dragGesture = DragGesture()
    private let currentSpan = 0.07
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: annotationItems) { item  in
                MapPin(coordinate: item.coordinate)
            }.gesture(dragGesture.onChanged({ (value) in
                /* Show a spinner ? */
            }).onEnded({ value in
                hitService()
            }))
            CurrentLocationView(region: $region)
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
        hitService()
    }
    
    private func hitService() {
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
        /*  TODO: Check why this line specifically is causing
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
