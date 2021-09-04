//
//  ApiServiceProtocol.swift
//  Airslip
//
//  Created by Graham Whitehouse on 05/08/2021.
//

import Foundation

protocol ApiServiceProtocol {
    func callApi<T: Decodable>(with url: String, method: ApiCallMethod, params: NSDictionary?, objectType: T.Type, completion: @escaping (Result<T>) -> Void)
    func callApiSyncronous<T: Decodable>(with url: String, method: ApiCallMethod, params: NSDictionary?, objectType: T.Type) -> Result<T>    
}
