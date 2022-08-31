//
//  CustomMapViewModelType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation

protocol CustomMapViewModelType{
   
    func getImage(imagePath: String, completion: @escaping(_ image: Data?)->Void)
}
