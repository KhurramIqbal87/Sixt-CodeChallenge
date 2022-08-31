//
//  BaseCellViewModelType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation

protocol BaseCellViewModelType{
    
    func getReusableIdentifierName()->String
    func getHeightForRow()->Float
}
