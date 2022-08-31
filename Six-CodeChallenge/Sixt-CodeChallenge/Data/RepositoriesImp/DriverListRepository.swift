//
//  DriverListRepository.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
class DriverListRepository: DriverListRepositoryType{
    
    private let networkManager: ApiClientType
    
    init(networkManager: ApiClientType = ApiClient.sharedInstance){
        self.networkManager = networkManager
    }
    
    func getDriverList( result: @escaping(driverList?, String?) -> Void) {
        let request = DriverListRequest.init()
        self.networkManager.getData(request: request) {  (response: driverList?, error) in
            
            result(response,error)
        }
     
    }
}
