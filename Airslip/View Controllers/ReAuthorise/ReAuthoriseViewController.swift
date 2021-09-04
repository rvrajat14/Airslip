//
//  ReAuthoriseViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 16/02/21.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

protocol RetryCallProtocol {
    func retryCall()
}

protocol ReceivingAirslipsSuccess {
    func alislipsSuccess()
}
class ReAuthoriseViewController: UIViewController {

    @IBOutlet weak var authoriseButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var authoriseButtonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var authoriseButtonView: UIView!
    
    var titleText = ""
    var authUrl = ""
    
    var isFromAccountsTransactionPage = true
    var receivingAirslipsSuccess : ReceivingAirslipsSuccess!
    var retryCallProtocol : RetryCallProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authoriseButton.setTitle((authUrl == "") ? "Retry" : "Authorise", for: .normal)
        self.titleLbl.text = self.titleText
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        if isFromAccountsTransactionPage {
            self.mainViewHeightConstraint.constant = (authUrl == "") ? 150 : 220
            self.authoriseButtonViewHeightConstraint.constant = 35
        }
        else {
            self.mainViewHeightConstraint.constant = 200
            self.authoriseButtonViewHeightConstraint.constant = 0
        }
        
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        if !isFromAccountsTransactionPage {
            receivingAirslipsSuccess.alislipsSuccess()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.mainView.layer.cornerRadius = 20
        self.authoriseButtonView.layer.cornerRadius = self.authoriseButtonView.frame.size.height/2
        self.authoriseButtonView.layer.masksToBounds = false
        self.authoriseButtonView.layer.backgroundColor = hexStringToUIColor(hex: "#F1F1F1").cgColor
        self.authoriseButtonView.layer.shadowColor = UIColor.darkGray.cgColor
        self.authoriseButtonView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        self.authoriseButtonView.layer.shadowRadius = 5.0
        self.authoriseButtonView.layer.shadowOpacity = 0.7
        self.authoriseButtonView.layer.masksToBounds = false
        self.authoriseButton.layer.cornerRadius = self.authoriseButton.frame.size.height/2
    }
    
    @IBAction func authoriseButton(_ sender: UIButton) {
        if self.authoriseButton.titleLabel?.text == "Retry" {
            self.dismiss(animated: true, completion: nil)
            self.retryCallProtocol.retryCall()
            return
        }
        self.fetchRedirectUrl(authUrl: self.authUrl)
    }
    
    func fetchRedirectUrl(authUrl: String) {
        SVProgressHUD .show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        
        var request = URLRequest(url: NSURL(string: authUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
        print(authUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        WebService.authenticationFunction()
        
        
        AF.request(request)
            .responseString { response in
                
                // do whatever you want here
                switch response.result {
                case .success(_):
                    if let data = response.data
                    {
                        print(JSON(data))
                        SVProgressHUD.dismiss()
                        
                        if let dataDictionary = JSON(data).dictionaryObject
                        {
                            if let errors = ((dataDictionary as NSDictionary)["errors"]) {
                                COMMON_FUNCTIONS.showAlert(msg: ((errors as! [NSDictionary])[0] ).value(forKey: "message") as! String, title: "")
                                self.dismiss(animated: true, completion: nil)
                                return
                            }
                            
                           let authorisationURL = ((dataDictionary as NSDictionary)["authorisationUrl"] as! String)
                            guard let url = URL(string: authorisationURL) else {
                                 return
                             }
                            if UIApplication.shared.canOpenURL(url) {
                                isFromDeepLink = true
                                userDefaults.setValue(isFromDeepLink, forKey: "isFromDeepLink")
                                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
                             }
                            else {
                                COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + authUrl, title: "")
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    SVProgressHUD.dismiss()
                    print(response.error.debugDescription)
                    break
                }
        }
    
    }  
}
