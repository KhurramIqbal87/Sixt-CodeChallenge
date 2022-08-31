//
//  BaseRequest.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 28/08/2022.
//

import Foundation
enum HttpMethod: String{
    case post = "POST"
    case get = "GET"
}

/// Base Request Object makes sure that request object of this types has all in the class need to call our network request.

protocol BaseRequest: Encodable{
    func getHttpRequestMethod()->HttpMethod
    func getHeaders()->[String: String]?
    func getBaseUrl()->String
    func getPath()->String
}


extension BaseRequest{
    func getBaseUrl()->String{
        return "https://cdn.sixt.io/"
    }
}
