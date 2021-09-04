//
//  AuthenticatedUserResponse.swift
//  Airslip
//
//  Created by Graham Whitehouse on 06/08/2021.
//

import Foundation

struct AuthenticatedUserResponse: Codable {
    var BearerToken: String
    var Expiry: Int64
    var RefreshToken: String
    var BiometricOn: Bool
    var IsNewUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case BearerToken = "bearerToken"
        case Expiry = "expiry"
        case RefreshToken = "refreshToken"
        case BiometricOn = "biometricOn"
        case IsNewUser = "isNewUser"
    }
}
