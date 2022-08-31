//
//  CustomMapViewModel.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation

final class CustomMapViewModel: CustomMapViewModelType{
    
    //MARK: - Stored Property
    
    private let repo: ImageRepositoryType
    
    //MARK: - Initializer
    
    init(repo: ImageRepositoryType ){
        self.repo = repo
    }
    
    //MARK: - Implementation
    
    func getImage(imagePath: String, completion: @escaping (Data?) -> Void) {
        
        self.repo.getImage(path: imagePath) { imageData in
            completion(imageData)
        }
    }
}
