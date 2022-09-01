//
//  CarListRepository.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation

class CarListRepository: CarListRepositoryType{
    
    private let networkManager: ApiClientType
    
    init(networkManager: ApiClientType = ApiClient.sharedInstance){
        self.networkManager = networkManager
    }
    
    func getCarList( result: @escaping(carList?, String?) -> Void) {
       
        let request = CarListRequest.init()
        
        self.networkManager.getData(request: request) {  (response: carList?, error) in
            
            result(response,error)
        }
    }
}
