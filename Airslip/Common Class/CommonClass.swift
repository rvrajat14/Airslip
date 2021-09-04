//
//  CommonClass.swift
//  Laundrit
//
//  Created by Kishore on 10/09/18.
//  Copyright © 2018 Kishore. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import SVProgressHUD
import Alamofire

class COMMON_FUNCTIONS {

    class func setView(view: UIView, hidden: Bool,option: UIView.AnimationOptions) {
        UIView.transition(with: view, duration: 1, options: option, animations: {
            view.isHidden = hidden
        })
    }
    
    
    class func addCustomTabBar()
    {

        DispatchQueue.main.async {
            UIApplication.shared.statusBarView?.backgroundColor = .white
            let viewController = UIApplication.shared.keyWindow?.rootViewController
            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)

            let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
             tabBarVC.tabBar.tintColor = MAIN_COLOR
   
//            let airslipsVC = storyBoard.instantiateViewController(withIdentifier: "AirslipsViewController") as! AirslipsViewController
//            let airslipsBarItem = UITabBarItem(title: "Airslips", image: #imageLiteral(resourceName: "airslips"), selectedImage: #imageLiteral(resourceName: "airslips"))
//            let airslipsNav = UINavigationController(rootViewController: airslipsVC)
//            airslipsNav.tabBarItem = airslipsBarItem
//            airslipsNav.isNavigationBarHidden = true


            let offersVC = storyBoard.instantiateViewController(withIdentifier: "OffersViewController") as! OffersViewController
            let offersBarItem = UITabBarItem(title: "Offers", image: #imageLiteral(resourceName: "offers"), selectedImage: #imageLiteral(resourceName: "offers"))
            let offersNav = UINavigationController(rootViewController: offersVC)
            offersNav.tabBarItem = offersBarItem
             offersNav.isNavigationBarHidden = true


            let manageVC = storyBoard.instantiateViewController(withIdentifier: "ManageViewController") as! ManageViewController
            let manageBarItem = UITabBarItem(title: "Manage", image: #imageLiteral(resourceName: "manage"), selectedImage: #imageLiteral(resourceName: "manage"))
            let manageNav = UINavigationController(rootViewController: manageVC)
            manageNav.tabBarItem = manageBarItem
            manageNav.isNavigationBarHidden = true

       
            
            if defaultHomePage || authenticatedUserNow {
                let homeVC = storyBoard.instantiateViewController(withIdentifier: "MyAccountsViewController") as! MyAccountsViewController
                let homeBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
                let homeNav = UINavigationController(rootViewController: homeVC)
                homeNav.isNavigationBarHidden = true
                homeNav.tabBarItem = homeBarItem
          
                tabBarVC.viewControllers = [homeNav,manageNav]
            }
            else {
                
                let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let homeBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
                let homeNav = UINavigationController(rootViewController: homeVC)
                homeNav.isNavigationBarHidden = true
                homeNav.tabBarItem = homeBarItem
                homeVC.isFromManageVC = false
            
            tabBarVC.viewControllers = [homeNav,manageNav]
            }
            tabBarVC.tabBarController?.tabBar.isHidden = false
            viewController?.navigationController?.isNavigationBarHidden = true

            let window = UIApplication.shared.delegate?.window!
            window?.rootViewController = tabBarVC
            window?.makeKeyAndVisible()
            tabBarVC.selectedIndex = 0
        }
    }
 
    class func showAlert (msg:String)
    {

        let viewController = UIApplication.shared.keyWindow?.rootViewController
 
       viewController?.view.makeToast(msg, duration: 4, position: .center, title: "", image: nil, style: .init(), completion: nil)
        viewController?.view.clearToastQueue()
        
    }
    
    class func showAlert (msg:String,title:String)
    {
        let attributedString = NSAttributedString(string: msg,
                                                  attributes: [NSAttributedString.Key.font : UIFont(name: REGULAR_FONT, size: 15)!])
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.setValue(attributedString, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            return
        }))
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        
        let popPresenter = alert.popoverPresentationController
        popPresenter?.sourceView = viewController?.view
        popPresenter?.sourceRect = (viewController?.view.bounds)!
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Get Color Name From Hex Code
    
   class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func getCorrectPriceFormat(price: String) -> String {
        if price.isEmpty {
            return ""
        }
        let newPrice = price.replacingOccurrences(of: ",", with: "")
        
        let float_value = Float(newPrice)
        return String(format: "%.2f", (float_value)!)
        
        
    }
    
   class func checkForNull(string: AnyObject) -> (Bool,String) {
        
        if string is NSNull {
            return (true,"")
        }
    let str = String(format: "%@",string as! CVarArg)
    
    if str.isEmpty {
       return (true,"")
    }
        return (false,str)
    }
    
    class func isValidPassword(password:String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{5,15}$"
        print(NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password))
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    class func isValidUserName(name:String) -> Bool {
        let nameRegex = "^[A-Za-z_][A-Za-z0-9_]{3,50}$"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }
    
    //MARK: -Email Validation
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    //Mark Update User Profile
    
    class func updateFaceId() {
    
        let params = [
            "biometricOn": biometricOn
        ]
//            SVProgressHUD.show()
//            SVProgressHUD.setDefaultStyle(.custom)
//            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
//            SVProgressHUD.setRingNoTextRadius(14.0)
//        let strUrl = APINAME.init().faceIdApi
        let strUrl = IDENTITY_BASE_URL + "/v1/identity/biometric"
        print(params )
    
        var request = URLRequest(url: NSURL(string: strUrl)! as URL)
        print(strUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        do
        {
            // json format
            let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let postString = NSString(data: body, encoding: String.Encoding.utf8.rawValue)
            print("Post Data -> \(String(describing: postString))")
            
            request.httpBody = body
        }
        catch let error as NSError
        {
            print(error)
        }

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        WebService.authenticationFunction()
        
    AF.request(strUrl, method: HTTPMethod.put, parameters: params, encoding: JSONEncoding.default, headers: headers)
        .response { (response) in
            print(response)
            print(response.response?.statusCode)
           let statusCode = response.response?.statusCode
            if (statusCode == 204) {
//                SVProgressHUD.dismiss()
//                COMMON_FUNCTIONS.showAlert(msg: "Profile Updated Successfully")
//                self.view.makeToast("Profile Updated Successfully", duration: 2, position: .center, title: "", image: nil, style: .init(), completion: {_ in
//                    self.navigationController?.popViewController(animated: true)
//                })
                userDefaults.setValue(biometricOn, forKey: "biometricOn")
                return
            }
            else {
                SVProgressHUD.dismiss()
                COMMON_FUNCTIONS.showAlert(msg: "SERVER ERROR")
            }
        }
//        .responseData { (response:DataResponse<Data>) in
//
//        switch(response.result) {
//        case .success(_):
//            if let data = response.data
//            {
//                print(JSON(data))
//                SVProgressHUD.dismiss()
//            }
//            break
//
//        case .failure(_):
//            SVProgressHUD.dismiss()
//            break
//        }
//
//
//    }
    }
}

class SHADOW_EFFECT {
    class func makeBottomShadow(forView view: UIView, shadowHeight: CGFloat = 5,color:UIColor = .lightGray,top_shadow: Bool = false, left:Bool = true, bottom:Bool = true, right:Bool = true ,cornerRadius: CGFloat = 4) {
        
        view.addshadow(top: top_shadow, left: left, bottom: bottom, right: right, shadowRadius:  2, color: color,cornerRadius: cornerRadius)
    }
}

extension UIView{
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 1.0, color: UIColor = .lightGray, cornerRadius: CGFloat = 4) {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.bounds.width
        var viewHeight = self.bounds.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+0)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}


extension UIViewController {
    
    func faceIDAuth() {
        let context = LAContext()
        var error : NSError?
        let splashView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let blurEffect = UIBlurEffect(style: .light)
            let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
            blurVisualEffectView.frame = view.bounds
            
            
            let splashImage = UIImage(named: "logo_text_2x")
            let imageView = UIImageView(image: splashImage)
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            imageView.contentMode = .scaleAspectFit
            
            let splashLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            splashLbl.font = UIFont(name: REGULAR_FONT, size: 15)
            splashLbl.text = "One universal app for all your receipts"
            splashLbl.textAlignment = .center
            
            splashView.addSubview(imageView)
            splashView.addSubview(splashLbl)
            splashView.backgroundColor = .white
            
            splashLbl.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: splashView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: splashView.centerYAnchor, constant: -50),
                imageView.heightAnchor.constraint(equalToConstant: 70),
                imageView.leadingAnchor.constraint(equalTo: splashView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                imageView.trailingAnchor.constraint(equalTo: splashView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                splashLbl.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor, constant: 75),
                splashLbl.leadingAnchor.constraint(equalTo: splashView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                splashLbl.trailingAnchor.constraint(equalTo: splashView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                splashLbl.heightAnchor.constraint(equalToConstant: 30),
                ])
            
            
            self.view.addSubview(splashView)
            
            var biometryType = ""
            switch context.biometryType {
            case .none:
                biometryType = ""
            case .touchID:
                biometryType = "Touch ID"
            case .faceID:
                biometryType = "Face ID"
           default:
                biometryType = ""
            }

            let reason = "Use \(biometryType) to authenticate on Airslip"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
                
                print(success)
                print(authenticationError)
                
                DispatchQueue.main.async {
                    if success {
//                        COMMON_FUNCTIONS.addCustomTabBar()
                        splashView.removeFromSuperview()
                        DispatchQueue.main.async {
                           NotificationCenter.default.post(name: Notification.Name("HideSplashView"), object: nil)
                         }
                    }
                    else {
                        splashView.removeFromSuperview()
                        print(error)
                        // error
//                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified; Please try again.", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default,handler: {_ in
//                            DispatchQueue.main.async {
//                                exit(-1)
//                            }
//                        }))
//                        self?.present(ac, animated: true)
                        DispatchQueue.main.async {
                            exit(-1)
                        }
                    }
                }
            }
        }
        else {
            splashView.removeFromSuperview()
            // No Biometrics
            let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device is not configured for biometry authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default,handler: {_ in
                DispatchQueue.main.async {
                    exit(-1)
                }
            }))
            present(ac, animated: true)
        }
    }
    
}

extension String {
func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
  let _font = font ?? UIFont(name: REGULAR_FONT, size: 14)
    let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font!])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: SEMIBOLD, size: 15)!]
    let range = (self as NSString).range(of: text)
  fullString.addAttributes(boldFontAttribute, range: range)

  return fullString
}
    
    func alertAttributedText(text: String, font: UIFont? = nil) -> NSAttributedString {
      let _font = font ?? UIFont(name: SEMIBOLD, size: 15)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font!])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: REGULAR_FONT, size: 12)!]
        let range = (self as NSString).range(of: text)
      fullString.addAttributes(boldFontAttribute, range: range)

      return fullString
    }
    
}
