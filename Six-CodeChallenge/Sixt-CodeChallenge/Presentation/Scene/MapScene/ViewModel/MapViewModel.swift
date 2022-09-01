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
    
    // MARK: - StoredProperties
    var errorPublisher: Published<String>.Publisher{$error}

    var filterCarPublisher: Published<[Car]>.Publisher{$filteredCars}
    
    var loadingPublisher: Published<Bool>.Publisher{$isLoading}
    
    @Published private var filteredCars: [Car] = []
    @Published private var isLoading: Bool = false
    @Published private var error: String = ""
    
    var radius: Double?
    var lastLocation: CLLocationCoordinate2D?
   
    private let repo: CarListRepositoryType
    private var cars: [Car] = []
    
    //MARK: - Initializer
    
    init(repo: CarListRepositoryType, cars: [Car] = []){
       
        self.repo = repo
        self.cars = cars
    }
    
    //MARK: - Implementations
    
    func getTitle() -> String {
        return "Find CAB"
    }
    
    func getFilteredCars(currentLocation: CLLocationCoordinate2D, radius: Double, refresh: Bool) {
        
        self.lastLocation = currentLocation
        self.radius = radius
        if self.cars.count == 0 || refresh{
            self.getCars{ [weak self] in
                
                self?.filteredCars(currentLocation: currentLocation, radius: radius)
            }
            return
        }
        self.filteredCars(currentLocation: currentLocation, radius: radius)
    }
  
   
    func refresh() {
        
        if let lastLocation = lastLocation, let radius = radius {
            
            self.getFilteredCars(currentLocation: lastLocation, radius: radius, refresh: true)
        }
    }
}

extension MapViewModel{
    /// This func getCar from Repository and viewModel updates ViewController using combine property for error or list.
     private func getCars(completion: ()->Void){
         
         self.isLoading = true
         self.repo.getCarList() { [weak self] (carList, error) in
             
             self?.isLoading = false
             
             if let error = error{
                 self?.error = error
             }
             
             if let cars = carList{
                 self?.cars = cars
             }
         }
     }
    
    private func filteredCars(currentLocation: CLLocationCoordinate2D, radius: Double ){
        
        self.filteredCars = self.cars.filter({ car in
            
            return car.getCLCoordinate().underReach(currentLocation2D: currentLocation, radius: radius)
        })
    }
}
