//
//  AboutViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/10/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import MapKit

class AboutViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let lat = 41.3111
    let long = 69.2796
    
    var manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupMapView()

    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
  
    func setupMapView() {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude : lat , longitude : long) , span: span)
        
        mapView.setRegion(region, animated: true)
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let pinObject = MKPointAnnotation()
        pinObject.coordinate = pinLocation
        pinObject.title = "Amir Timur Square"
        pinObject.subtitle = ""
        
        self.mapView.addAnnotation(pinObject)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        
    }

  
}
