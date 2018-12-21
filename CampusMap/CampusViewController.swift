//
//  CampusViewController.swift
//  CampusMap
//
//  Created by Chun on 2018/11/26.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit
import MapKit


class CampusViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var campus = Campus(filename: "Campus")
    var selectedOptions : [MapOptionsType] = []
    
    var locationManager = CLLocationManager()
    
    var lastLocation:POIAnnotation = POIAnnotation.init(coordinate: CLLocationCoordinate2D.init(), title: "我的位置", subtitle: "", type: POIType(rawValue: 14)!)
    var curLocation:POIAnnotation = POIAnnotation.init(coordinate: CLLocationCoordinate2D.init(), title: "我的位置", subtitle: "", type: POIType(rawValue: 14)!)
    
    let adjust_latitude = -0.002113
    let adjust_longitude = 0.004983
    
    var destination = CLLocationCoordinate2D.init()
    var drawRoute:Bool = false
    var direction = MKDirections.init(request: MKDirections.Request())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latDelta = campus.overlayTopLeftCoordinate.latitude - campus.overlayBottomRightCoordinate.latitude
        
        // Think of a span as a tv size, measure from one corner to another
        let span = MKCoordinateSpan.init(latitudeDelta: fabs(latDelta), longitudeDelta: 0.0)
        let region = MKCoordinateRegion.init(center: campus.midCoordinate, span: span)
        
        mapView.mapType = MKMapType.standard
        mapView.region = region
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.delegate = self;
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? MapOptionsViewController)?.selectedOptions = selectedOptions
    }
    
    
    // MARK: Helper methods
    func loadSelectedOptions() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        for option in selectedOptions {
            switch (option) {
            case .mapPOIsSchoolBuilding, .mapPOIsFood, .mapPOIsDormitory, .mapPOIsSport, .mapPOIsGate, .mapPOIsOtherBuilding:
                self.addPOIs(item: option)
            case .mapBoundary:
                self.addBoundary()
            }
        }
    }
    
    
    @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue) {
        guard let vc = exitSegue.source as? MapOptionsViewController else { return }
        selectedOptions = vc.selectedOptions
        loadSelectedOptions()
    }
    
    
    func addBoundary() {
        mapView.addOverlay(MKPolygon(coordinates: campus.boundary, count: campus.boundary.count))
        mapView.addAnnotation(curLocation)
    }
    
    
    func addPOIs(item: MapOptionsType) {
        guard let pois = Campus.plist("CampusPOI") as? [[String : String]] else { return }
        
        var types = [Int]()
        switch item {
        case .mapPOIsSchoolBuilding:
            types.append(4)
        case .mapPOIsDormitory:
            types.append(8)
        case .mapPOIsFood:
            types.append(2)
        case .mapPOIsSport:
            types.append(contentsOf: [1,11,12,13])
        case .mapPOIsGate:
            types.append(0)
        case .mapPOIsOtherBuilding:
            types.append(contentsOf: [3,5,6,7,9,10])
        case .mapBoundary:
            print("Error")
        }
        
        for poi in pois {
            if types.contains(Int(poi["type"]!)!){
                let coordinate = Campus.parseCoord(dict: poi, fieldName: "location")
                let title = poi["name"] ?? ""
                let typeRawValue = Int(poi["type"] ?? "0") ?? 0
                let type = POIType(rawValue: typeRawValue)!
                let subtitle = poi["subtitle"] ?? ""
                let annotation = POIAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
                mapView.addAnnotation(annotation)
                mapView.addAnnotation(curLocation)
            }
        }
    }
    
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapView.removeAnnotation(lastLocation)
        
        let annotation = POIAnnotation(coordinate: (locations.last?.coordinate)!, title: "我的位置", subtitle: "", type: POIType(rawValue: 14)!)
        
        curLocation = annotation
        curLocation.coordinate.latitude = curLocation.coordinate.latitude + adjust_latitude
        curLocation.coordinate.longitude = curLocation.coordinate.longitude + adjust_longitude
 
        mapView.addAnnotation(curLocation)
        
        lastLocation = curLocation
        
    }
    
    // MARK: - showRouteOnMap
    func showRouteOnMap() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: curLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        direction = MKDirections(request: request)
        
        direction.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.addOverlay(unwrappedResponse.routes[0].polyline)
//                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
                
            }
        }
    }
    
    func deleteRouteOnMap() {
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
}


// MARK: - MKMapViewDelegate
extension CampusViewController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.red
            lineView.lineWidth = CGFloat(2.0)
            return lineView
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.blue
            polygonView.lineWidth = CGFloat(3.0)
            return polygonView
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = POIAnnotationView(annotation: annotation, reuseIdentifier: "POI")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if drawRoute == false{
            drawRoute = true
            destination = (view.annotation?.coordinate)!
            showRouteOnMap()
        }
        else{
            drawRoute = false
            deleteRouteOnMap()
        }
    }
}
