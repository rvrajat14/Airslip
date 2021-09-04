//
//  RootViewController.swift
//  Airslip
//
//  Created by Rajat Verma on 09/06/21.
//

import UIKit

class RootViewController: UIViewController {

    var window = UIApplication.shared.delegate?.window!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logoutNotificationAction), name: NSNotification.Name?.init(NSNotification.Name(rawValue: "LogoutNotification")), object: nil)
        
        if userDefaults.value(forKey: "user_email") != nil {
            access_token = COMMON_FUNCTIONS.checkForNull(string: userDefaults.value(forKey: "access_token") as AnyObject).1
            isNewUser = COMMON_FUNCTIONS.checkForNull(string: userDefaults.value(forKey: "isNewUser") as AnyObject).0
            biometricOn =  userDefaults.value(forKey: "biometricOn") as? Bool ?? false
//            COMMON_FUNCTIONS.addCustomTabBar()
            self.callApi()
        }
        else {
            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
            window = UIWindow(frame: UIScreen.main.bounds)
            let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? UINavigationController
            if let window = self.window {
                self.window?.rootViewController = yourVc
            }
            self.window?.makeKeyAndVisible()
        }
    }
    
    
    @objc func logoutNotificationAction(_ notification: NSNotification)
    {
        
        DispatchQueue.main.async {
           
            userDefaults.removeObject(forKey: "user_email")
            userDefaults.removeObject(forKey: "access_token")
            userDefaults.removeObject(forKey: "biometricOn")
            userDefaults.removeObject(forKey: "isNewUser")
            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? UINavigationController
            if let window = self.window {
                window.rootViewController = yourVc
            }
            self.window?.makeKeyAndVisible()
            
        }
    }
    
    //Mark :- Logout Api
    
    func callLogoutApi() {
        WebService.requestGetUrl(strURL: APINAME.init().logout, params: [:], is_loader_required: true) { (response) in
            print(response)
            userDefaults.removeObject(forKey: "user_email")
            UserDefaults.standard.removeObject(forKey: "access_token")
            UserDefaults.standard.removeObject(forKey: "isNewUser")
            UserDefaults.standard.removeObject(forKey: "biometricOn")
       
            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? UINavigationController
            if let window = self.window {
                window.rootViewController = yourVc
            }
            self.window?.makeKeyAndVisible()
            
        } failure: { (error) in
            print(error)
        }

    }
    
    // Mark :- Call Accounts Api
    
    func callApi() {
    
        WebService.requestGetUrl(strURL: APINAME.init().accounts, params: [:], is_loader_required: true) { (response) in
            print(response)
   
            if let error = (response["errors"]) {
                COMMON_FUNCTIONS.showAlert(msg: ((error as! [NSDictionary])[0]).value(forKey: "message") as! String, title: "")
                return
            }
            
            if let res = response["accounts"] {
                if (res as! [NSDictionary]).count > 0 {
                    defaultHomePage = true
                    authenticatedUserNow = false
                    COMMON_FUNCTIONS.addCustomTabBar()
                }
                else {
                    defaultHomePage = false
                    authenticatedUserNow = false
                    COMMON_FUNCTIONS.addCustomTabBar()
       
                }
          
            }
   
        } failure: { (error) in
            print(error)
        }
    }
    
   

}
