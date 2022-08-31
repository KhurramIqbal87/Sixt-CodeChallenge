//
//  NetworkError.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
public enum NetworkError{
    case noInternet
    case networkError(error: HTTPStatusCode)
    case dataSerializationError(error: String)
    case error(error: Error)
    
    func getErrorMessage()->String{
        switch self {
        case .noInternet:
            return "Please Connect to internet"
        case .networkError(error: let error):
            return error.codeDescription()
        case .dataSerializationError(_):
            return "Corrupt data"
        case .error(let error):
            return error.localizedDescription
        }
       
    }
    
}
