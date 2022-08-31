//
//  MapViewModel.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation


import Foundation
import Combine
import CoreLocation
final class MapViewModel: MapViewModelType{
    var errorPublisher: Published<String>.Publisher{$error}

    var filterDriverPublisher: Published<[Driver]>.Publisher{$filteredDrivers}
    
    var loadingPublisher: Published<Bool>.Publisher{$isLoading}

    var radius: Double?
    var lastLocation: CLLocationCoordinate2D?
    
    @Published private var filteredDrivers: [Driver] = []
    @Published private var isLoading: Bool = false
    @Published private var error: String = ""
   
    private let repo: DriverListRepositoryType
    private var drivers: [Driver] = []
    
    init(repo: DriverListRepositoryType, drivers: [Driver] = []){
        self.repo = repo
        self.drivers = drivers
    }
    
    func getTitle() -> String {
        return "Find CAB"
    }
    
    func getFilteredDrivers(currentLocation: CLLocationCoordinate2D, radius: Double, refresh: Bool) {
        
        self.lastLocation = currentLocation
        self.radius = radius
        if self.drivers.count == 0 || refresh{
            self.getDrivers{ [weak self] in
                self?.filteredDrivers(currentLocation: currentLocation, radius: radius)
            }
            return
        }
        self.filteredDrivers(currentLocation: currentLocation, radius: radius)
    }
  
   
    private func filteredDrivers(currentLocation: CLLocationCoordinate2D, radius: Double ){
        self.filteredDrivers = self.drivers.filter({ driver in
            return driver.getCLCoordinate().underReach(currentLocation2D: currentLocation, radius: radius)
        })
    }
    
   /// This func getDrivers or Car from Repository and viewModel updates ViewController using combine property for error or list.
    private func getDrivers(completion: ()->Void){
        
        self.isLoading = true
        self.repo.getDriverList() { [weak self] (driverList, error) in
            
            self?.isLoading = false
            
            if let error = error{
                self?.error = error
            }
            
            if let drivers = driverList{
                self?.drivers = drivers
            }
        }
    }
    
    func refresh() {
        if let lastLocation = lastLocation, let radius = radius {
            
            self.getFilteredDrivers(currentLocation: lastLocation, radius: radius, refresh: true)
        }
    }
    
}
