//
//  ImageRepositoryType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation

protocol ImageRepositoryType{
    func getImage(path: String, completion:@escaping (_ imageData: Data?)->Void)
}

extension ImageRepositoryType{
    
    /// default implementation of the func
    
    func getImage(path: String, completion:@escaping (_ imageData: Data?)->Void){
      
        let networkSharedInstance = ApiClient.sharedInstance
        
        networkSharedInstance.downloadData(url: path) { data, error in
            
            completion(data)
        }
    }
}
