//
//  AppDelegate+Injection.swift
//  Airslip
//
//  Created by Graham Whitehouse on 03/08/2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {

        register { ApiService() as ApiServiceProtocol }.scope(.graph)
        register { UserService() as UserServiceProtocol }.scope(.graph)
        register { DialogueService() as DialogueServiceProtocol }.scope(.graph)
        register { UrlService() as UrlServiceProtocol }.scope(.graph)
        register { BankTransactionService() as BankTransactionServiceProtocol }.scope(.graph)
        register { AuthenticationService() as AuthenticationServiceProtocol }.scope(.graph)
    }
}
