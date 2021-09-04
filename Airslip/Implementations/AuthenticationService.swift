//
//  AuthenticationService.swift
//  Airslip
//
//  Created by Graham Whitehouse on 05/08/2021.
//

import Foundation
import Resolver
import Alamofire

class AuthenticationService : NSObject, AuthenticationServiceProtocol {
    
    @Injected var apiService: ApiServiceProtocol
    @Injected var userService: UserServiceProtocol
    @Injected var urlService: UrlServiceProtocol
    
    override init() {
        super.init()
    }
    
    func login(emailAddress: String!, password: String!, deviceId: String) {
        
        // Build params for submission
//        let params = ["email" :emailAddress!,
//                      "password": password!,
//                      "deviceId": deviceId]
        
        // Call the apiService
        // apiService.post();
        
    }
    
    func refresh() {
        userService.refresh()
        
        if userService.tokenExpiryDate != nil && Date() > userService.tokenExpiryDate {
            
            let url = urlService.urlFor(authenticationServiceType: AuthenticationServiceType.Refresh)

            let params = ["refreshToken": refresh_token,
                         "deviceId": deviceId]
            
            let result = apiService
                .callApiSyncronous(with: url.url, method: url.method, params: params as NSDictionary, objectType: AuthenticatedUserResponse.self)
            
            switch result {
            case .Success(let object):
                print(object)
                userService.bearerToken = object.BearerToken
                userService.refreshToken = object.RefreshToken
                userService.tokenExpiryDate = Date(milliseconds: object.Expiry)
                
            case .Failure(let error):
                print(error)
                NotificationCenter.default.post(name: NSNotification.Name.init("LogoutNotification"), object: nil)
            }
        }
    }
}

struct ToDo: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool

}
