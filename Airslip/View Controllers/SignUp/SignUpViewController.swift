//
//  SignUpViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 11/02/21.
//

import UIKit
import PasswordTextField
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController , UIGestureRecognizerDelegate{

    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var googleLoginView: UIView!
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    
    }
    
    override func viewDidLayoutSubviews() {
        
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
        
        self.signUpButton.layer.cornerRadius = 4
        self.signUpButton.layer.shadowColor = UIColor.black.cgColor
        self.signUpButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.signUpButton.layer.shadowRadius = 5
        self.signUpButton.layer.shadowOpacity = 0.3
        
        self.facebookLoginView.layer.cornerRadius = 4
        SHADOW_EFFECT.makeBottomShadow(forView: self.googleLoginView, shadowHeight: 10, top_shadow: true)
    }
    
    
    @IBAction func signInButton(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func signUpButton(_ sender: UIButton) {
                if emailTextField.text == "" {
                    COMMON_FUNCTIONS.showAlert(msg: "Please input the email.", title: "")
                    return
                }
        
                if passwordTextField.text == "" {
                    COMMON_FUNCTIONS.showAlert(msg: "Please input the password.",title: "")
                    return
                }
        
                if !COMMON_FUNCTIONS.isValidEmail(testStr: emailTextField.text!) {
                    COMMON_FUNCTIONS.showAlert(msg: "Invaild email. Please input the correct email.",title: "")
                    return
                }
        self.callSignUpApi()
       
    }

    @IBAction func googleLoginButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func facebookLoginButton(_ sender: UIButton) {
        
    }
    
    
    func callSignUpApi() {
        let signUpUrl = IDENTITY_BASE_URL + "/v1/identity/register"
        let params = ["email"
                        :emailTextField.text!,
                      "password": passwordTextField.text!]
        
        SVProgressHUD .show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)

        let headers : HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        print(headers)
        
        AF.request(signUpUrl, method: HTTPMethod.post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in

            switch(response.result) {
            case .success(_):
                if let data = response.data
                {
                     SVProgressHUD.dismiss()
                    
                    print(JSON(data).dictionaryObject)
                    if let dataDictionary = JSON(data).dictionaryObject
                    {
                        
                        if let bearer_token = (dataDictionary["bearerToken"]) {
                            access_token = bearer_token as! String
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
                        if let error = (dataDictionary["errors"]) {
                            COMMON_FUNCTIONS.showAlert(msg: ((error as! [NSDictionary])[0]).value(forKey: "message") as! String, title: "")
                        }
                    }             
                }
                break
                
            case .failure(_):
                 SVProgressHUD.dismiss()
                COMMON_FUNCTIONS.showAlert(msg: "Unable to SignUp", title: "")
                break
            }
   
        }
    }
    
}
