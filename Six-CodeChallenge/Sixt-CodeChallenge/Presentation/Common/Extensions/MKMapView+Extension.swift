//
//  MKMapView+Extension.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import MapKit
extension MKMapView {

    func topCenterCoordinate() -> CLLocationCoordinate2D {
        
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }

    func currentRadius() -> Double {
        
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        
        let topCenterCoordinate = self.topCenterCoordinate()
        
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        return centerLocation.distance(from: topCenterLocation)
    }
}
