//
//  Driver.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation



import Foundation
import CoreLocation

typealias driverList = [Driver]

// MARK: - Driver
struct Driver: Codable {
    let id, modelIdentifier, modelName, name: String
    let make: String
    let group: Group
    let color, series: String
    let fuelType: FuelType
    let fuelLevel: Double
    let transmission: Transmission
    let licensePlate: String
    let latitude, longitude: Double
    let innerCleanliness: InnerCleanliness
    let carImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, modelIdentifier, modelName, name, make, group, color, series, fuelType, fuelLevel, transmission, licensePlate, latitude, longitude, innerCleanliness
        case carImageURL = "carImageUrl"
    }
 
}
//MARK: - Convert lat long into cllcordinate
extension Driver{
    func getCLCoordinate()->CLLocationCoordinate2D{
        return CLLocationCoordinate2D.init(latitude: self.latitude, longitude: self.longitude)
    }
}

enum FuelType: String, Codable {
    case d = "D"
    case e = "E"
    case p = "P"
    
    func getFullValue()->String{
        switch self{
        case .d: return "Diesel"
        case .e: return "Electric"
        case .p: return "Petrol"
        }
    }
}

enum Group: String, Codable {
    case bmw = "BMW"
    case mini = "MINI"
}

enum InnerCleanliness: String, Codable {
    case clean = "CLEAN"
    case regular = "REGULAR"
    case veryClean = "VERY_CLEAN"
   
    func getFullValue()->String{
        switch self{
        case .clean: return "Clean"
        case .regular: return "Normal"
        case .veryClean: return "Super Clean"
        }
    }
}

enum Transmission: String, Codable {
    case a = "A"
    case m = "M"
    
    func getFullValue()->String{
        switch self{
        case .a: return "Automatic"
        case .m: return "Manual"
        }
    }
}



