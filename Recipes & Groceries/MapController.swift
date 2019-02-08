//
//  MapController.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/5/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLon:Double?
    var userLat:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //see if the app has authorization to get the users location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //get and display the user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLon = locValue.longitude
        userLat = locValue.latitude
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if error != nil {
        } else {
            if (placemarks?.count)! > 0
            {
                let placemark = placemarks![0]
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                self.map.setRegion(region, animated: true)
                
                //remove all previous annotations
                let prevAni = self.map.annotations
                self.map.removeAnnotations(prevAni)
                
                //search the area for grocery stores
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = "Grocery Store"
                request.region = self.map.region
                let search = MKLocalSearch(request: request)
                
                search.start { (response, error) in
                    if response == nil {
                        
                    } else {
                        var matchingItems:[MKMapItem] = []
                        matchingItems = response!.mapItems
                        
                        //loop through all grocery stores and display them
                        if matchingItems.count > 1 {
                            for i in 1...matchingItems.count-1 {
                                let ani = MKPointAnnotation()
                                let place = matchingItems[i].placemark
                                ani.coordinate = place.location!.coordinate
                                ani.title = place.name
                                
                                self.map.addAnnotation(ani)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
