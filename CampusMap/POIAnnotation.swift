//
//  POIAnnotation.swift
//  CampusMap
//
//  Created by Chun on 2018/11/27.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit
import MapKit

enum POIType: Int {
    case gate = 0
    case ride = 1
    case food = 2
    case firstAid = 3
    case schoolBuilding = 4
    case mountain = 5
    case supermarket = 6
    case library = 7
    case dormitory = 8
    case entertainment = 9
    case observatory = 10
    case swimming = 11
    case basketball = 12
    case playground = 13
    case myLocation = 14
    
    func image() -> UIImage {
        switch self {
        case .gate:
            return #imageLiteral(resourceName: "star")
        case .ride:
            return #imageLiteral(resourceName: "ride")
        case .food:
            return #imageLiteral(resourceName: "food")
        case .firstAid:
            return #imageLiteral(resourceName: "firstaid")
        case .schoolBuilding:
            return #imageLiteral(resourceName: "school-building")
        case .mountain:
            return #imageLiteral(resourceName: "moutain")
        case .supermarket:
            return #imageLiteral(resourceName: "supermarket")
        case .library:
            return #imageLiteral(resourceName: "library")
        case .dormitory:
            return #imageLiteral(resourceName: "dormitory")
        case .entertainment:
            return #imageLiteral(resourceName: "entertainment")
        case .observatory:
            return #imageLiteral(resourceName: "observatory")
        case .swimming:
            return #imageLiteral(resourceName: "swimming")
        case .basketball:
            return #imageLiteral(resourceName: "basketball")
        case .playground:
            return #imageLiteral(resourceName: "playground")
        case .myLocation:
            return #imageLiteral(resourceName: "myLocation")
        }
    }
}

class POIAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: POIType
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: POIType) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}
