//
//  UrlGeneratorService.swift
//  Airslip
//
//  Created by Graham Whitehouse on 05/08/2021.
//

import Foundation
import Alamofire

class UrlService: NSObject, UrlServiceProtocol {
    
    private var webUrls: WebUrls? = nil
    
    override init() {
        super.init()
        
        self.loadWebUrls()
    }
    
    func baseUrlFor(apiType: BaseApiType) -> String {
        var url = ""

        switch apiType {
        case BaseApiType.BankTransactions:
            url = "\(webUrls?.bankTransactionsUrl ?? "")"
        case BaseApiType.Identity:
            url = "\(webUrls?.authenticationUrl ?? "")"
        case BaseApiType.MerchantDatabase:
            url = "\(webUrls?.merchantDatabaseUrl ?? "")"
        }
        
        return url
    }
    
    func urlFor(authenticationServiceType: AuthenticationServiceType) -> (url: String, method: ApiCallMethod) {
        var url = ""
        var method: ApiCallMethod = ApiCallMethod.Get
        
        switch authenticationServiceType {
        case AuthenticationServiceType.Login:
            url = "\(webUrls?.authenticationUrl ?? "")/v1/login"
            method = ApiCallMethod.Post
        case AuthenticationServiceType.Refresh:
            url = "\(webUrls?.authenticationUrl ?? "")/v1/identity/refresh"
            method = ApiCallMethod.Post
        case AuthenticationServiceType.Logout:
            url = "\(webUrls?.authenticationUrl ?? "")/v1/logout"
            method = ApiCallMethod.Get
        }
        
        return (url: url, method: method)
    }
    
    private func loadWebUrls() {
        if  let path        = Bundle.main.path(forResource: "WebUrls", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let loadedWebUrls     = try? PropertyListDecoder().decode(WebUrls.self, from: xml)
        {
            print(loadedWebUrls.baseUrl)
            webUrls = loadedWebUrls
        }
    }
    
}
