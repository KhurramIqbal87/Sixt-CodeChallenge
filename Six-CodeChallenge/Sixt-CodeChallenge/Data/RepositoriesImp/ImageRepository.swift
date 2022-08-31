//
//  ImageRepository.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
final class ImageRepository: ImageRepositoryType{
   
    //MARK: - Stored Properties
    
    static let sharedInstance = ImageRepository.init()
    
    private let clientManager: ApiClientType
    
    //MARK: - Initializers
    
    init(clientManager: ApiClientType = ApiClient.sharedInstance){
        
        self.clientManager = clientManager
    }
    //MARK: - Implementation
    
    func getImage(path: String, completion:@escaping (_ imageData: Data?)->Void){
       
        self.clientManager.downloadData(url: path) { data, error in
            
            completion(data)
        }
    }
}
