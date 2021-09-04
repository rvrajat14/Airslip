//
//  AuthenticationServiceProtocol.swift
//  Airslip
//
//  Created by Graham Whitehouse on 05/08/2021.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func login(emailAddress: String!, password: String!, deviceId: String)
    func refresh()
}
