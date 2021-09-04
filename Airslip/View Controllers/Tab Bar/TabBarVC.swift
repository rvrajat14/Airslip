//
//  TabBarVC.swift
//  FoodApplication
//
//  Created by Kishore on 30/05/18.
//  Copyright © 2018 Kishore. All rights reserved.
//

import UIKit
import GoogleSignIn

class TabBarVC: UITabBarController {
    
    var isStoreSelected = false
    var window : UIWindow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logoutNotificationAction), name: NSNotification.Name?.init(NSNotification.Name(rawValue: "LogoutNotification")), object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(faceIdAuthCalled(notification:)), name: Notification.Name("FaceIdAuthentication"), object: nil)
    }
    
    @objc func faceIdAuthCalled(notification:Notification)
        {
            self.faceIDAuth()
            return
        }
    
    func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return ""
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func logoutNotificationAction(_ notification: NSNotification)
    {
        
        DispatchQueue.main.async {
           
            userDefaults.removeObject(forKey: "user_email")
            userDefaults.removeObject(forKey: "access_token")
            userDefaults.removeObject(forKey: "biometricOn")
            userDefaults.removeObject(forKey: "isNewUser")
            userDefaults.removeObject(forKey: "expireDate")
            userDefaults.removeObject(forKey: "refresh_token")
            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? UINavigationController
            if let window = self.window {
                window.rootViewController = yourVc
            }
            GIDSignIn.sharedInstance().signOut()
            self.window?.makeKeyAndVisible()
            
        }
        
//        let alert = UIAlertController(title: "Blocked By Admin", message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "z_ok".getLocalizedValue(), style: .default, handler: { (action) in
//            DispatchQueue.main.async {
//
//                productCartArray.removeAllObjects()
//                UserDefaults.standard.removeObject(forKey: "user_data")
//                let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? UINavigationController
//                if let window = self.window {
//                    window.rootViewController = yourVc
//                }
//                self.window?.makeKeyAndVisible()
//
//            }
//        }))
//
//        let popPresenter = alert.popoverPresentationController
//        popPresenter?.sourceView = self.view
//        popPresenter?.sourceRect = (self.view.bounds)
//        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
