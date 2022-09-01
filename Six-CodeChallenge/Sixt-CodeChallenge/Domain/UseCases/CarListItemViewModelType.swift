//
//  CarListItemViewModelType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import CoreLocation
/// CarListViewModelType is an abstraction layer for our cell class.
protocol CarListItemViewModelType: BaseCellViewModelType{
    
    func getName()->String
    func getType()->String
    func getImage(completion: @escaping(_ image: Data?)->Void)
    func getLicensePlate()->String
    func getFuelType()->String
    func getTransmissionType()->String
    func getCleaniness()->String

}
