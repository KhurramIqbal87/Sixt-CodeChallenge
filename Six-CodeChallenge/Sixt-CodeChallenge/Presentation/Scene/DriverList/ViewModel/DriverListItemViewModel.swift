//
//  DriverListItemViewModel.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import CoreLocation
final class DriverListItemViewModel: DriverListItemViewModelType {
    
    //MARK:  - Properties
    private let repo: ImageRepositoryType
    private var imageData: Data?
    
    private let id: String
    private let make: String
    private let modelName: String
    private let name: String
    private let licensePlate: String
    private let transmission: String
    private let fuelType: String
    private let cleanniess: String
    private let imageUrl: String
    
    init(model: Driver, repo: ImageRepositoryType = ImageRepository.sharedInstance){
       
        self.repo = repo
        
        self.make = model.make
        self.modelName = model.modelName
        self.licensePlate = model.licensePlate
        self.imageUrl = model.carImageURL
        self.name = model.name
        self.id = model.id
        
        self.transmission = model.transmission.getFullValue()
        self.cleanniess = model.innerCleanliness.getFullValue()
        self.fuelType = model.fuelType.getFullValue()
    
    }
   
    
    func getReusableIdentifierName() -> String {
        return "\(DriverListTableViewCell.self)"
    }
    
    func getHeightForRow() -> Float {
        return 130
    }

    func getName()->String{
        return self.name
    }
    func getType()->String{
        return self.make + " " + self.modelName
    }
    
    func getLicensePlate() -> String {
        return self.licensePlate 
    }
    
    func getFuelType() -> String {
        return self.fuelType
    }
    
    func getTransmissionType() -> String {
        return self.transmission
    }
    
    func getCleaniness() -> String {
        return self.cleanniess
    }
    
   
    
    func getImage(completion: @escaping (Data?) -> Void) {
        if let imageData = imageData{
            completion(imageData)
            return
        }
        self.repo.getImage(path: self.imageUrl) { [weak self] imageData in
            self?.imageData = imageData
            completion(imageData)
        }
    }
}
