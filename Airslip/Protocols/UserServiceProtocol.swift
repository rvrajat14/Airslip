//
//  UserServiceProtocol.swift
//  Airslip
//
//  Created by Graham Whitehouse on 04/08/2021.
//

import Foundation

protocol UserServiceProtocol {
    
    var bearerToken: String { get set }
    var refreshToken: String { get set }
    var userEmail: String { get set }
    var isNewUser: Bool! { get set }
    var biometricOn: Bool! { get set }
    var isLoggedIn: Bool! { get set }
    var tokenExpiryDate: Date! { get set }
    var deviceId: String? { get }
    
    func clear()
    func refresh()
}
