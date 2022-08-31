//
//  MockRepository.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
class MockDriverListRepository: DriverListRepositoryType{
   
    func getDriverList( result: @escaping(driverList?, String?) -> Void) {
        
        result(self.getMockDrivers(), nil)
        
    }
    private func getMockDrivers()->driverList{
      
        let driver1 = Driver.init(id: "11", modelIdentifier: "", modelName: "Tanto", name: "Khurram", make: "Daihatsu", group: .mini, color: "", series: "", fuelType: .p, fuelLevel: 0.9, transmission: .a, licensePlate: "BGM - 634", latitude: 48.162771, longitude: 11.592978, innerCleanliness: .veryClean, carImageURL: "")
        
        let driver2 = Driver.init(id: "11", modelIdentifier: "", modelName: "Tanto2", name: "Khurram", make: "Daihatsu", group: .mini, color: "", series: "", fuelType: .p, fuelLevel: 0.9, transmission: .a, licensePlate: "BGM - 634", latitude: 58.162771, longitude: 21.592978, innerCleanliness: .veryClean, carImageURL: "")
        return [driver1, driver2]
    }
 
}
