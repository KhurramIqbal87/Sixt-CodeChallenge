//
//  CarListRepositoryType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation

protocol CarListRepositoryType{
    
    typealias Result = (_ carList: carList?, _ error: String?)->Void
    
    func getCarList( result: @escaping Result )
}
