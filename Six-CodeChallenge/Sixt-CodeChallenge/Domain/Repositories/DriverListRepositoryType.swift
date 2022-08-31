//
//  DriverListRepositoryType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation

protocol DriverListRepositoryType{
    
    typealias Result = (_ driverList: driverList?, _ error: String?)->Void
    
    func getDriverList( result: @escaping Result )
}
