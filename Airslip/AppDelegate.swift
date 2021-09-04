//
//  AppDelegate.swift
//  Airslip
//
//  Created by Rahul Verma on 10/02/21.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import GooglePlaces
import GoogleMaps
import Firebase
import GoogleSignIn
//import FBSDKLoginKit

let MAIN_COLOR:UIColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 178.0/255.0, alpha: 1)
let REGULAR_FONT = "Poppins"
let ITALIC = "Poppins-Italic"
let SEMIBOLD = "Poppins-Semibold"
let ITALIC_SEMIBOLD = "Poppins-SemiboldItalic"
let BOLD = "Poppins-Bold"

//let BASE_URL = "https://dev-app.airslip.com/bank_transactions"
let BASE_URL = "https://airslip-bank-transactions-api.azurewebsites.net"
let IDENTITY_BASE_URL = "https://dev-auth.airslip.com"
let userDefaults = UserDefaults.standard
var defaultHomePage = true
var authenticatedUserNow = false
var authorisationUrl = ""
var access_token = ""
var refresh_token = ""
var token_type = "Bearer"
var isNewUser : Bool!
var biometricOn = false
var isFromDeepLink = false

var LIGHT_BORDER_COLOR = "#dfe4ea"
var GOOGLE_KEY = "AIzaSyC32hr5Ddnx5lN6OK_teItekafCxgnl2tE"

let deviceId = UIDevice.current.identifierForVendor?.uuidString
//AIzaSyC32hr5Ddnx5lN6OK_teItekafCxgnl2tE

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance()?.clientID = "22029806966-9jijhj50a10krkh2p7kvposvo525buol.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        GMSPlacesClient.provideAPIKey(GOOGLE_KEY)
        GMSServices.provideAPIKey(GOOGLE_KEY)
        
        // Use the Firebase library to configure APIs.
        FirebaseApp.configure()
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        }
        else {
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let familyName = user.profile.familyName
            let givenName = user.profile.givenName
            let email = user.profile.email
            
            print(email ?? "email not coming")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has Disconnected")
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance().handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        isFromDeepLink = userDefaults.value(forKey: "isFromDeepLink") as? Bool ?? false
        biometricOn = userDefaults.value(forKey: "biometricOn") as? Bool ?? false
        if let isFrom = userDefaults.value(forKey: "isFromDeepLink") {
            print(isFrom)
        }
        print(biometricOn)
        if biometricOn && !isFromDeepLink{
            NotificationCenter.default.post(name: Notification.Name("FaceIdAuthentication"), object: nil)
          }
        else {
            isFromDeepLink = false
            userDefaults.setValue(false, forKey: "isFromDeepLink")
        }
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
   
    //MARK: Open App from Web Site
    internal func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?
        ) -> Void) -> Bool {
        
        guard let url = userActivity.webpageURL else { return false }
        
        authorisationUrl = url.absoluteString
        print(url.absoluteString)
        defaultHomePage = false
        authenticatedUserNow = true
        COMMON_FUNCTIONS.addCustomTabBar()
        
        return false
    }
}

