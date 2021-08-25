//
//  LocationManager.swift
//  Rain
//
//  Created by apple on 26/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate  {
    
    static let shared = LocationManager()
    
    private var location_manager : CLLocationManager?
    
    private var gotLocationOfUser : ((_ lat:CLLocationDegrees?, _ long:CLLocationDegrees?)->())?
    
    var lastLocation : CLLocationCoordinate2D?
    
    func getUserLocation(_ completion:@escaping (_ lat:CLLocationDegrees?, _ long:CLLocationDegrees?)->()){
        
        self.gotLocationOfUser = completion
        self.location_manager = CLLocationManager()
        self.location_manager?.requestWhenInUseAuthorization()
        self.location_manager?.delegate = self
        self.location_manager?.startUpdatingLocation()
    }
    
    func stopLocationUpdate(){
        
        if self.location_manager != nil{
            self.location_manager?.stopUpdatingLocation()
            self.location_manager?.delegate = nil
            print("...stop getting location....")
        }
        
    }
    
    //MARK:- --- Delegate ----
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate{
            lastLocation = location
            self.gotLocationOfUser?(location.latitude,location.longitude)
        }else{
            self.gotLocationOfUser?(nil,nil)
        }
    }
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.gotLocationOfUser?(nil,nil)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            print("authorized Always")
        case .authorizedWhenInUse:
            print("authorized WhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            print("invalid")
        }
        
        self.gotLocationOfUser?(nil,nil)
    }
}

extension CLLocation {
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                                -> Void ) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self, preferredLocale: Locale.current) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        }
        // Look up the location and pass it to the completion handler
    }
}
