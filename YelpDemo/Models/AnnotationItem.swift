//
//  AnnotationItem.swift
//  YelpDemo
//
//  Created by rhalfer on 26/01/2021.
//

import Foundation
import MapKit

struct AnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    var business: BusinessModel
    let id = UUID()
}
