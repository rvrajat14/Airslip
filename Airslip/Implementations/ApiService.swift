//
//  ApiService.swift
//  Airslip
//
//  Created by Graham Whitehouse on 05/08/2021.
//

import Foundation
import Resolver
import Alamofire

class ApiService: NSObject, ApiServiceProtocol {
    
    @Injected var dialogueService: DialogueServiceProtocol
    @Injected var urlService: UrlServiceProtocol
    @Injected var userService: UserServiceProtocol
    
    func callApi<T: Decodable>(with url: String, method: ApiCallMethod, params: NSDictionary?, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {

        // Build the request
        let request: URLRequest = getUrlRequest(with: url, method: method, params: params)

        print("callApi Called")
        print("url: \(url)")
        print("method: \(method)")
        
        //create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            print(response.statusCode)

            guard error == nil else {
                completion(Result.Failure(ApiError.NetworkError(error!)))
                return
            }

            guard let data = data else {
                completion(Result.Failure(ApiError.DataNotFound))
                return
            }
            
            guard (200...299).contains(status) else {
                completion(Result.Failure(ApiError.InvalidStatusCode(status)))
                return
            }

            do {
                print(data)
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.Success(decodedObject))
            } catch let error {
                completion(Result.Failure(ApiError.JsonParsingError(error as! DecodingError)))
            }
        })

        task.resume()
    }
    
    
    func callApiSyncronous<T: Decodable>(with url: String, method: ApiCallMethod, params: NSDictionary?, objectType: T.Type) -> Result<T> {
        var result: Result<T> = Result.Failure(ApiError.ProcessIncomplete)
        let semaphore = DispatchSemaphore(value: 0)
        
        print("callApiSyncronous Called")
        print("url: \(url)")
        print("method: \(method)")
        
        self.callApi(with: url, method: method, params: params, objectType: objectType) { (output: Result) in
            result = output
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return result
    }
    
    private func getUrlRequest(with url: String, method: ApiCallMethod, params: NSDictionary?) -> URLRequest {
        let dataURL = URL(string: url)!
        var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if userService.isLoggedIn {
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        }
        switch method {
        case ApiCallMethod.Get:
            request.httpMethod = "GET"
        case ApiCallMethod.Post:
            request.httpMethod = "POST"
        }
        
        do {
            if method == ApiCallMethod.Post {
                let body = try JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
                request.httpBody = body
            }
        } catch let error as NSError
        {
            print(error)
        }
        
        return request
    }
}
