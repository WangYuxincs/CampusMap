//
//  CampusMapOverlay.swift
//  CampusMap
//
//  Created by Chun on 2018/11/27.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit
import MapKit


class CampusMapOverlay: NSObject, MKOverlay {
    
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(campus: Campus) {
        boundingMapRect = campus.overlayBoundingMapRect
        coordinate = campus.midCoordinate
    }
}
