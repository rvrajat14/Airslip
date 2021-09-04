//
//  UrlGeneratorProtocol.swift
//  Airslip
//
//  Created by Graham Whitehouse on 04/08/2021.
//

import Foundation
import Alamofire

protocol UrlServiceProtocol{
    func baseUrlFor(apiType: BaseApiType) -> String
    func urlFor(authenticationServiceType: AuthenticationServiceType) -> (url: String, method: ApiCallMethod)
}
