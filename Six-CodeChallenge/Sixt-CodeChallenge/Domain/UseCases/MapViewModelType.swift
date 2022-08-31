//
//  MapViewModelType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import CoreLocation
import Combine
/// to enable our MapviewController to work with any implementation we have created the abstraction Layer so we can make our code testable
/// MapviewModel used Combine to published its data, error handling, and handle loading states.
protocol MapViewModelType: BaseViewModel{
   
    var filterDriverPublisher: Published<[Driver]>.Publisher{get}
    var loadingPublisher: Published<Bool>.Publisher{get}
    var errorPublisher: Published<String>.Publisher{get}
    var lastLocation: CLLocationCoordinate2D?{get}
    var radius: Double?{get}
    

    func getTitle()->String
    func getFilteredDrivers(currentLocation:CLLocationCoordinate2D, radius: Double, refresh: Bool)
    func refresh()
    
    
}
