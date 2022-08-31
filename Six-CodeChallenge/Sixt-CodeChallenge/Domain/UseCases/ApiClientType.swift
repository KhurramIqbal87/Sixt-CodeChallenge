//
//  ApiClientType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 28/08/2022.
//


import Foundation

// At times our network library can be switched to 3rd party or our new driven implementation for mock data or for handling data using publisher. This will make sure that repository is flexible enough to handle new implementation

protocol ApiClientType{
    // It takes request object and Codable Response type so we donot have to provide each things separately and we make sure that respective class handles things for respective work.
    func getData<Request: BaseRequest, Response: Decodable>  (request: Request, completion:@escaping ((_ response: Response?,_ error: String? )->Void))
    
    
    func downloadData(url: String, completion:@escaping ((_ data: Data?, _ error: Error?) -> Void)) 
}
