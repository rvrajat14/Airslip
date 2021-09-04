//
//  ViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 10/02/21.
//

import UIKit
import PasswordTextField
import SVProgressHUD
import Alamofire
import SwiftyJSON
import LocalAuthentication
import GoogleSignIn

class LoginViewController: UIViewController, UIGestureRecognizerDelegate, GIDSignInDelegate {

    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var googleLoginView: UIView!
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBOutlet weak var loginDescriptionLbl: UILabel!
    @IBOutlet weak var loginDescriptionLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblTermsHeightConstraint: NSLayoutConstraint!
    
    let text = "By signing up you accept the Terms of Services and Privacy Policy"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        lblTerms.text = text
        self.lblTerms.textColor =  UIColor.black
        let attriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms of Services")
        let range2 = (text as NSString).range(of: "Privacy Policy")
//             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        attriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: REGULAR_FONT, size: 16)!, range: range1)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value: MAIN_COLOR, range: range1)
        attriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: REGULAR_FONT, size: 16)!, range: range2)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value: MAIN_COLOR, range: range2)
        lblTerms.attributedText = attriString
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))

        lblTermsHeightConstraint.constant = lblTerms.heightForLabel() + 20
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    

    @objc func tapLabel(gesture: UITapGestureRecognizer) {
       
    let termsRange = (text as NSString).range(of: "Terms of Services")
    // comment for now
    let privacyRange = (text as NSString).range(of: "Privacy Policy")

    if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termsRange) {
        print("Tapped terms")
    } else if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: privacyRange) {
        print("Tapped privacy")
    } else {
        print("Tapped none")
    }
    }
    
    override func viewDidLayoutSubviews() {
        
        self.loginDescriptionLblHeightConstraint.constant = self.loginDescriptionLbl.heightForLabel()
        
        self.emailView.layer.borderColor = hexStringToUIColor(hex: LIGHT_BORDER_COLOR).cgColor
        self.emailView.layer.borderWidth = 1
        self.passwordView.layer.borderColor = hexStringToUIColor(hex: LIGHT_BORDER_COLOR).cgColor
        self.passwordView.layer.borderWidth = 1
        self.emailView.layer.cornerRadius = 6
        self.passwordView.layer.cornerRadius = 6

        let color = hexStringToUIColor(hex: LIGHT_BORDER_COLOR)
        let emailPlaceholder = emailTextField.placeholder ?? ""
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        let passwordPlaceholder = passwordTextField.placeholder ?? ""
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.signInButton.layer.cornerRadius = 4
        self.facebookLoginView.layer.cornerRadius = 4
        SHADOW_EFFECT.makeBottomShadow(forView: self.googleLoginView, shadowHeight: 10, top_shadow: true)
//        SHADOW_EFFECT.makeBottomShadow(forView: self.signInView, shadowHeight: 10, top_shadow: true)
        self.signInButton.layer.shadowColor = UIColor.black.cgColor
        self.signInButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.signInButton.layer.shadowRadius = 5
        self.signInButton.layer.shadowOpacity = 0.3
    }

    @IBAction func signInButton(_ sender: UIButton) {
//        COMMON_FUNCTIONS.addCustomTabBar()
        if emailTextField.text == "" {
            COMMON_FUNCTIONS.showAlert(msg: "Please enter your email", title: "")
            return
        }

        if passwordTextField.text == "" {
            COMMON_FUNCTIONS.showAlert(msg: "Please enter your password",title: "")
            return
        }

        if !COMMON_FUNCTIONS.isValidEmail(testStr: emailTextField.text!) {
            COMMON_FUNCTIONS.showAlert(msg: "Invaild email. Please enter the correct email.",title: "")
            return
        }
        self.callLoginApi()
    }
 
    @IBAction func signUpButton(_ sender: UIButton) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    
    @IBAction func googleLoginButton(_ sender: UIButton) {
//        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        self.present(webVC, animated: true, completion: nil)
    
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        }
        else {
            print(user!)
//            let userId = user.userID
//            let idToken = COMMON_FUNCTIONS.checkForNull(string: user.authentication.idToken as AnyObject).1
            let fullName =  COMMON_FUNCTIONS.checkForNull(string: user.profile.name as AnyObject).1
            let familyName =  COMMON_FUNCTIONS.checkForNull(string: user.profile.familyName as AnyObject).1
            let givenName = COMMON_FUNCTIONS.checkForNull(string: user.profile.givenName as AnyObject).1
            let email = COMMON_FUNCTIONS.checkForNull(string: user.profile.email as AnyObject).1
            let photo = COMMON_FUNCTIONS.checkForNull(string: user.profile.imageURL(withDimension: 100) as AnyObject).1

            let googleLoginUrl = IDENTITY_BASE_URL + "/v1/identity/google"
            let params = [ "email": email,
                           "name": fullName,
                           "picture": photo,
                           "locale": "",
                           "family_name": familyName,
                           "given_name": givenName,
                           "deviceId": deviceId
                ]

                SVProgressHUD.show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)

                let headers : HTTPHeaders = [
                    "Content-Type": "application/json"
                ]
                print(headers)
                WebService.authenticationFunction()
                
                AF.request(googleLoginUrl, method: HTTPMethod.post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in

                    switch(response.result) {
                    case .success(_):
                        if let data = response.data
                        {
                             SVProgressHUD.dismiss()
                            
                            print(JSON(data).dictionaryObject!)
                            if let dataDictionary = JSON(data).dictionaryObject
                            {
                                print(dataDictionary)
                                if let error = (dataDictionary["errors"]) {
                                    COMMON_FUNCTIONS.showAlert(msg: ((error as! [NSDictionary])[0]).value(forKey: "message") as! String, title: "")
                                }
                                
                                if (dataDictionary as NSDictionary).value(forKey: "biometricOn") != nil {
                                    biometricOn = (dataDictionary as NSDictionary).value(forKey: "biometricOn") as? Bool ?? false
                                }
                                isNewUser = (dataDictionary as NSDictionary).value(forKey: "isNewUser") as? Bool ?? false
                                userDefaults.setValue((dataDictionary as NSDictionary).value(forKey: "isNewUser") as? Bool, forKey: "isNewUser")
                                userDefaults.setValue((dataDictionary as NSDictionary).value(forKey: "biometryOn") as? Bool, forKey: "biometryOn")
                                
                                if let bearer_token = (dataDictionary["bearerToken"]) {
                                    access_token = bearer_token as! String
                                    userDefaults.setValue(access_token, forKey: "access_token")
                                }
                                
                                if let refresh_token1 = (dataDictionary["refreshToken"]) {
                                    refresh_token = refresh_token1 as! String
                                    userDefaults.setValue(refresh_token, forKey: "refresh_token")
                                }
                                
                                if let expiry = (dataDictionary["expiry"]) {
                                    let expireTime = (expiry as! NSNumber)
                                    let expireDate = Date(milliseconds: Int64(truncating: expireTime))
                                    userDefaults.setValue(expireDate, forKey: "expireDate")
                                }
                                
                                if let links = (dataDictionary["_links"]) {
                                    if (links as! [NSDictionary]).count > 0 {
                                        for item in (links as! [NSDictionary]) {
                                            if (item.value(forKey: "href") as! String).contains("accounts") {
                                                defaultHomePage = true
                                                authenticatedUserNow = false
                                            }
                                            if (item.value(forKey: "href") as! String).contains("institutions") {
                                                defaultHomePage = false
                                                authenticatedUserNow = false
                                            }
                                        }
                                        
                                        userDefaults.setValue(self.emailTextField.text!, forKey: "user_email")
                                        COMMON_FUNCTIONS.addCustomTabBar()
                                    }
                                    else {
                                        COMMON_FUNCTIONS.showAlert(msg: dataDictionary["message"] as! String, title: "")
                                    }
                                }
                                print(dataDictionary)
                            }
                        }
                        break
                        
                    case .failure(_):
                         SVProgressHUD.dismiss()
                        COMMON_FUNCTIONS.showAlert(msg: "Unable to login", title: "")
                        break
                    }
                    
                }
            
            
        }
    }
    
    
    func callLoginApi() {
    
        let loginUrl = IDENTITY_BASE_URL + "/v1/identity/login"
        let params = ["email"
                        :emailTextField.text!,
                      "password": passwordTextField.text! ,
                      "deviceId": deviceId]

        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)

        let headers : HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        print(headers)
        WebService.authenticationFunction()
        
        AF.request(loginUrl, method: HTTPMethod.post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in

            switch(response.result) {
            case .success(_):
                if let data = response.data
                {
                     SVProgressHUD.dismiss()
                    
    
                    if let dataDictionary = JSON(data).dictionaryObject
                    {
                        print(dataDictionary)
                        if let error = (dataDictionary["errors"]) {
                            COMMON_FUNCTIONS.showAlert(msg: ((error as! [NSDictionary])[0]).value(forKey: "message") as! String, title: "")
                        }
                        
                        if (dataDictionary as NSDictionary).value(forKey: "biometricOn") != nil {
                            biometricOn = (dataDictionary as NSDictionary).value(forKey: "biometricOn") as? Bool ?? false
                 
                        }
                        isNewUser = (dataDictionary as NSDictionary).value(forKey: "isNewUser") as? Bool ?? false
                        userDefaults.setValue((dataDictionary as NSDictionary).value(forKey: "isNewUser") as? Bool, forKey: "isNewUser")
                        print(biometricOn)
                        userDefaults.setValue((dataDictionary as NSDictionary).value(forKey: "biometricOn") as? Bool, forKey: "biometricOn")
                        
                        if let bearer_token = (dataDictionary["bearerToken"]) {
                            access_token = bearer_token as! String
                            userDefaults.setValue(access_token, forKey: "access_token")
                        }
                        
                        if let refresh_token1 = (dataDictionary["refreshToken"]) {
                            refresh_token = refresh_token1 as! String
                            userDefaults.setValue(refresh_token, forKey: "refresh_token")
                        }
                        
                        if let expiry = (dataDictionary["expiry"]) {
                            let expireTime = (expiry as! NSNumber)
                          
                            let expireDate = Date(milliseconds: Int64(truncating: expireTime))
                            userDefaults.setValue(expireDate, forKey: "expireDate")
                        }
                        
                        if let links = (dataDictionary["_links"]) {
                            
                            
                            if (links as! [NSDictionary]).count > 0 {
                                for item in (links as! [NSDictionary]) {
                                    if (item.value(forKey: "href") as! String).contains("accounts") {
                                        defaultHomePage = true
                                        authenticatedUserNow = false
                                    }
                                    if (item.value(forKey: "href") as! String).contains("banks") {
                                        defaultHomePage = false
                                        authenticatedUserNow = false
                                    }
                                }
                                
                                userDefaults.setValue(self.emailTextField.text!, forKey: "user_email")
                                COMMON_FUNCTIONS.addCustomTabBar()
                            }
                            else {
                                COMMON_FUNCTIONS.showAlert(msg: dataDictionary["message"] as! String, title: "")
                            }
                        }
               
                        print(dataDictionary)
                  
                    }
                }
                break
                
            case .failure(_):
                 SVProgressHUD.dismiss()
                COMMON_FUNCTIONS.showAlert(msg: "Unable to login", title: "")
                break
            }
            
        }
    }
}


extension UITapGestureRecognizer {

 func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
     let layoutManager = NSLayoutManager()
     let textContainer = NSTextContainer(size: CGSize.zero)
     let textStorage = NSTextStorage(attributedString: label.attributedText!)

     // Configure layoutManager and textStorage
     layoutManager.addTextContainer(textContainer)
     textStorage.addLayoutManager(layoutManager)

     // Configure textContainer
     textContainer.lineFragmentPadding = 0.0
     textContainer.lineBreakMode = label.lineBreakMode
     textContainer.maximumNumberOfLines = label.numberOfLines
     let labelSize = label.bounds.size
     textContainer.size = labelSize

     // Find the tapped character location and compare it to the specified range
     let locationOfTouchInLabel = self.location(in: label)
     let textBoundingBox = layoutManager.usedRect(for: textContainer)
     //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                           //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
     let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

     //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                     // locationOfTouchInLabel.y - textContainerOffset.y);
     let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
     let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
     return NSLocationInRange(indexOfCharacter, targetRange)
 }

}
