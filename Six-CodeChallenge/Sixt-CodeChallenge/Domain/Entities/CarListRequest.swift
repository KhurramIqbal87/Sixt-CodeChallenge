//
//  CarListRequest.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
struct CarListRequest: BaseRequest, Encodable{
   
    //MARK: - StoredProperties
   
    private let path = "codingtask/cars"
    
    
    //MARK: - Implementations
    func getHttpRequestMethod() -> HttpMethod {
        return .get
    }
    
    func getHeaders() -> [String : String]? {
        return  nil
    }
    
    func getPath() -> String {
        return self.getBaseUrl() + self.path
    }
}

//MARK: - EncodedKeys

extension CarListRequest{
    
    enum CodingKeys: CodingKey {
    }
}
