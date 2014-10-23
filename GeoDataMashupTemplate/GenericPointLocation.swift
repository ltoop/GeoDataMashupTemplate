//
//  GenericPointLocation.swift
//  GeoDataMashupTemplate
//
//  Created by Luke Toop on 21/10/2014.
//  Copyright (c) 2014 luketoop.com. All rights reserved.
//

import UIKit
import MapKit

struct GenericPointLocation {
    let name: String
    let latitude: Double
    let longitude: Double
    
    // Value could be any type, but let's keep it simple for now and use a number.
    let value: Double
    
    init( name: String, latitude: Double, longitude: Double, value: Double) {
        self.name       = name
        self.latitude   = latitude
        self.longitude  = longitude
        self.value      = value
    }
    
    func mkPointAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
        annotation.title = self.name
        return annotation
    }
}