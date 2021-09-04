//
//  UserService.swift
//  Airslip
//
//  Created by Graham Whitehouse on 04/08/2021.
//

import Foundation
import Resolver

class UserService : NSObject, UserServiceProtocol {

    internal var bearerTokenInt: String = ""
    internal var refreshTokenInt: String = ""
    internal var userEmailInt: String = ""
    internal var isLoggedInInt: Bool! = false
    internal var isNewUserInt: Bool! = false
    internal var biometricOnInt:Bool! = false
    internal var tokenExpiryDateInt:Date! = nil

    var tokenExpiryDate: Date! {
        get {
            return tokenExpiryDateInt
        }
        set {
            tokenExpiryDateInt = newValue
            self.updateUserData()
        }
    }
    
    var isLoggedIn: Bool! {
        get {
            return isLoggedInInt
        }
        set {
            isLoggedInInt = newValue
            self.updateUserData()
        }
    }
    
    var bearerToken: String {
        get {
            return bearerTokenInt
        }
        set {
            bearerTokenInt = newValue
            self.updateUserData()
        }
    }
    
    var refreshToken: String {
        get {
            return refreshTokenInt
        }
        set {
            refreshTokenInt = newValue
            self.updateUserData()
        }
    }
    
    var userEmail: String {
        get {
            return userEmailInt
        }
        set {
            userEmailInt = newValue
            self.updateUserData()
        }
    }
    
    var isNewUser: Bool! {
        get {
            return isNewUserInt
        }
        set {
            isNewUserInt = newValue
            self.updateUserData()
        }
    }
    
    var biometricOn: Bool! {
        get {
            return biometricOnInt
        }
        set {
            biometricOnInt = newValue
            self.updateUserData()
        }
    }
    
    var deviceId: String? {
        get {
            return UIDevice.current.identifierForVendor?.uuidString
        }
    }
    
    override init() {
        super.init()

        self.refresh()
    }
    
    func clear() {
        bearerTokenInt = "";
        refreshTokenInt = "";
        userEmailInt = "";
        isNewUserInt = false;
        biometricOnInt = false;
        isLoggedInInt = false
        tokenExpiryDateInt = nil
        
        self.updateUserData()
    }
    
    func refresh() {
        tokenExpiryDateInt = self.getUserValueAsDate(keyName: "expireDate")
        bearerTokenInt = self.getUserValueAsString(keyName: "access_token")
        refreshTokenInt = self.getUserValueAsString(keyName: "refresh_token")
        userEmailInt = self.getUserValueAsString(keyName: "user_email")
        isNewUserInt = self.getUserValueAsBool(keyName: "isNewUser")
        biometricOnInt = self.getUserValueAsBool(keyName: "biometricOn")
        isLoggedInInt = self.getUserValueAsBool(keyName: "isLoggedIn")
    }
    
    private func getUserValueAsString(keyName: String) -> String {
        var result: String = ""
        
        if UserDefaults.standard.value(forKey: keyName) != nil
        {
            result = (UserDefaults.standard.value(forKey: keyName) as! String)
        }
        
        return result
    }
    
    private func getUserValueAsBool(keyName: String) -> Bool {
        var result: Bool = false
        
        if UserDefaults.standard.value(forKey: keyName) != nil
        {
            result = UserDefaults.standard.value(forKey: keyName) as! Bool
        }
        
        return result
    }
    
    private func getUserValueAsDate(keyName: String) -> Date! {
        var result: Date! = nil
        
        if UserDefaults.standard.value(forKey: keyName) != nil
        {
            result = UserDefaults.standard.value(forKey: keyName) as? Date
        }
        
        return result
    }
    
    private func updateUserData() {
        UserDefaults.standard.setValue(isNewUserInt, forKey: "isNewUser")
        UserDefaults.standard.setValue(userEmailInt, forKey: "user_email")
        UserDefaults.standard.setValue(bearerTokenInt, forKey: "access_token")
        UserDefaults.standard.setValue(refreshTokenInt, forKey: "refresh_token")
        UserDefaults.standard.setValue(biometricOnInt, forKey: "biometricOn")
        UserDefaults.standard.setValue(isLoggedInInt, forKey: "isLoggedIn")
        UserDefaults.standard.setValue(tokenExpiryDateInt, forKey: "expireDate")
    }
}
