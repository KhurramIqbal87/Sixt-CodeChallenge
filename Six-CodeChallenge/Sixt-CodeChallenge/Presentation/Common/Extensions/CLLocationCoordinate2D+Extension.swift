//
//  CLLocationCoordinate2D+Extension.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import CoreLocation

/// we want to check if a pin point is under our radius
extension CLLocationCoordinate2D{
    
    func underReach(currentLocation2D: CLLocationCoordinate2D, radius: Double)->Bool{
        
        let currentLocaiton = CLLocation(latitude: currentLocation2D.latitude, longitude: currentLocation2D.longitude)
        
        let pointLocation = CLLocation.init(latitude: self.latitude, longitude: self.longitude)
        
       let distance =  currentLocaiton.distance(from: pointLocation)
        
        return  radius > distance
    }
    
    
}
