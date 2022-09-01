//
//  MockCarRepository.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
class MockCarListRepository: CarListRepositoryType{
   
    func getCarList( result: @escaping(carList?, String?) -> Void) {
        
        result(self.getMockCars(), nil)
        
    }
    private func getMockCars()->carList{
      
        let car1 = Car.init(id: "11", modelIdentifier: "", modelName: "Tanto", name: "Khurram", make: "Daihatsu", group: .mini, color: "", series: "", fuelType: .p, fuelLevel: 0.9, transmission: .a, licensePlate: "BGM - 634", latitude: 48.162771, longitude: 11.592978, innerCleanliness: .veryClean, carImageURL: "")
        
        let car2 = Car.init(id: "11", modelIdentifier: "", modelName: "Tanto2", name: "Khurram", make: "Daihatsu", group: .mini, color: "", series: "", fuelType: .p, fuelLevel: 0.9, transmission: .a, licensePlate: "BGM - 634", latitude: 58.162771, longitude: 21.592978, innerCleanliness: .veryClean, carImageURL: "")
        return [car1, car2]
    }
 
}
