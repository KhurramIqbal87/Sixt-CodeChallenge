//
//  ApiClient.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation

// I have use NSURLSession for our network Communication.

final class ApiClient: ApiClientType{
    
    typealias Header = [String: String]
   
    //MARK: - Stored Properties
    static let sharedInstance = ApiClient.init()
    private let session = URLSession.shared
    
    init(){}

    func getData<Request, Response>(request: Request, completion: @escaping ((Response?, String?) -> Void)) where Request : BaseRequest, Response : Decodable {
        if !Reachability.isConnectedToNetwork(){
            completion(nil,NetworkError.noInternet.getErrorMessage())
            return
        }
        
        guard let urlRequest = self.getURLRequest(path: request.getPath(), headers: request.getHeaders(), paramaters: request, httpMethod: request.getHttpRequestMethod())else{
            completion(nil, "Invalid Request")
            return
        }
        let task = self.session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let self = self else{
                completion(nil, "Technical Error")
                return
            }
            guard  error == nil  else{
                completion(nil, self.handleError(urlResponse: response))
                return
            }
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: ", jsonString)
                }
                do {
                    
                    let obj = try JSONDecoder().decode(Response.self, from: data)

                    completion(obj, nil)
                }  catch {
                    print(error.localizedDescription)
                    completion(nil,NetworkError.error(error: error).getErrorMessage())
                }
            } else{
                completion(nil, "Corrupt Data")
            }
            
            
        }
        task.resume()
    }
    
    private func handleError( urlResponse: URLResponse?)->String{
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else{return " Technical Error"}
        
        let statusCode = httpURLResponse.statusCode
        
        
        guard let errorCode = HTTPStatusCode(rawValue: statusCode) else{return "Technical Error"}
        let networkError = NetworkError.networkError(error: errorCode)
      
        return networkError.getErrorMessage()
    }
    
    
    private func getURLRequest<Request>(path: String, headers: Header?, paramaters: Request?, httpMethod: HttpMethod )->URLRequest? where Request: Encodable{
        
       
        guard let url = URL(string: path) else{return nil}
        var urlRequest = URLRequest(url: url)
        
        /// check if request is non Get type create encode data and attached it to body else convert parameters into queryString and create new URL 
        if let paramData = paramaters, let data = try? JSONEncoder().encode(paramData){
            if httpMethod != .get{
                urlRequest.httpBody = data
            } else{
                if let dict = paramaters?.dictionary, dict.count > 0{
                    var urlComponent = URLComponents.init(string: path)
                    urlComponent?.queryItems =    dict.compactMap { (key,val) -> URLQueryItem in
                        
                        return URLQueryItem.init(name: key, value: val as? String)
                    }
                    urlRequest = URLRequest.init(url: urlComponent?.url ?? url)
                }
            }
            
        }
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    func downloadData(url: String, completion:@escaping ((_ data: Data?, _ error: Error?) -> Void)) {
        if let saveData = Filing.sharedInstance.getFile(fileName: url){
            completion(saveData,nil)
            return
        }
        guard let url = URL(string: url) else{return}
      /*  group.enter()
        semaphore.wait()
        queue.async(group: group){*/
        let fileSharing = Filing.sharedInstance
        let task = self.session.dataTask(with: url, completionHandler: { [weak fileSharing]data, urlResponse, error in
           
            if let data = data{
                fileSharing?.saveFile(data: data, fileName: url.lastPathComponent, fileExtension: url.pathExtension)
            }
            completion(data,error)
//            self.semaphore.signal()
//            self.group.leave()
        })
        task.resume()
//        }
     
        
    }
   
}
