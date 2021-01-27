//
//  CurrentLocationView.swift
//  YelpDemo
//
//  Created by rhalfer on 26/01/2021.
//

import SwiftUI
import MapKit

struct CurrentLocationView: View {
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        HStack {
            if Int(region.center.latitude) != 0 && Int(region.center.longitude) != 0 {
                Text("latitude: \(region.center.latitude)")
                Text("longitude: \(region.center.longitude)")
            } else {
                Text("Loading location...")
            }
        }.foregroundColor(.green)
    }
}

struct CurrentLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationView(region: .constant(MKCoordinateRegion()))
    }
}
