//
//  PermissionViewController.swift
//  Airslip
//
//  Created by Rajat Verma on 18/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

protocol CantFetchAccountsDelegate {
    func cantFetchAccounts(msg:String)
}
class PermissionViewController: UIViewController {

    
    @IBOutlet weak var dataSharingInfoButton: UIButton!
    @IBOutlet weak var dataSharingTitleLbl: UILabel!
    @IBOutlet weak var dataSharingInfoView: UIView!
    @IBOutlet weak var dataSharingInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secureConnectionTitleLbl: UILabel!
    @IBOutlet weak var secureConnectionInfoButton: UIButton!
    @IBOutlet weak var secureConnectionInfoView: UIView!
    @IBOutlet weak var secureConnectionInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fcaAuthorisationTitleLbl: UILabel!
    @IBOutlet weak var fcaAuthorisationInfoButton: UIButton!
    @IBOutlet weak var fcaAuthorisationInfoView: UIView!
    @IBOutlet weak var fcaAuthorisationInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var detailsLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var identificationDetailsLbl: UILabel!
    @IBOutlet weak var identificationDetailsDot: UIView!
    @IBOutlet weak var accountDetailsLbl: UILabel!
    @IBOutlet weak var accountDetailsDot: UIView!
    @IBOutlet weak var balancesLbl: UILabel!
    @IBOutlet weak var balancesDot: UIView!
    @IBOutlet weak var transactionDetailsLbl: UILabel!
    @IBOutlet weak var transactionDetailsDot: UIView!
    @IBOutlet weak var transactionDetailsLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var creditCardDetailsLbl: UILabel!
    @IBOutlet weak var creditCardDetailsDot: UIView!
    @IBOutlet weak var creditCardDetailsLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var allowTheAccessLbl: UILabel!
    @IBOutlet weak var allowTheAccessInfoButton: UIView!
    @IBOutlet weak var allowTheAccessInfoView: UIView!
    @IBOutlet weak var allowTheAccessInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var allowTheAccessTextView: UITextView!
    @IBOutlet weak var fcaAuthorisationtextView: UITextView!
    @IBOutlet weak var secureConnectionTextView: UITextView!
    @IBOutlet weak var dataSharingTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var authUrl = ""
    var instituteName = ""
    var cantFetchAccountsDelegate : CantFetchAccountsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.dataSharingInfoViewHeightConstraint.constant = 0
        self.secureConnectionInfoViewHeightConstraint.constant = 0
        self.fcaAuthorisationInfoViewHeightConstraint.constant = 0
        self.allowTheAccessInfoViewHeightConstraint.constant = 0
        self.dataSharingInfoView.isHidden = true
        self.secureConnectionInfoView.isHidden = true
        self.fcaAuthorisationInfoView.isHidden = true
        self.allowTheAccessInfoView.isHidden = true
        self.identificationDetailsDot.layer.cornerRadius = self.identificationDetailsDot.frame.height/2
        self.accountDetailsDot.layer.cornerRadius = self.accountDetailsDot.frame.height/2
        self.balancesDot.layer.cornerRadius = self.balancesDot.frame.height/2
        self.transactionDetailsDot.layer.cornerRadius = self.transactionDetailsDot.frame.height/2
        self.creditCardDetailsDot.layer.cornerRadius = self.creditCardDetailsDot.frame.height/2
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2
        self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/2
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.cancelButton.layer.borderWidth = 1
        self.dataSharingInfoView.layer.borderWidth = 1
        self.secureConnectionInfoView.layer.borderWidth = 1
        self.fcaAuthorisationInfoView.layer.borderWidth = 1
        self.allowTheAccessInfoView.layer.borderWidth = 1
      
  
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = +90
        let nintyDaysFromToday = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        
        self.detailsLbl.text = "Airslip Limited is in partnership with SafeConnect and in order to share your \(instituteName) data with Airslip Limited, you will now be securely redirected to your bank to confirm your consent for SafeConnect to read the following information"
        self.allowTheAccessTextView.text = "SafeConnect will use these details with Airslip Limited solely for the purposes of Airslip to provide you with smart receipts. This access is valid until \(formatter.string(from: nintyDaysFromToday!)), you can cancel consent at any time via the manage tab or via your bank. This request is not a one-off, you will continue to receive consent requests as older versions expire."
        self.detailsLblHeightConstraint.constant = self.detailsLbl.heightForLabel()
        self.transactionDetailsLblHeightConstraint.constant = self.transactionDetailsLbl.heightForLabel()
        self.creditCardDetailsLblHeightConstraint.constant = self.creditCardDetailsLbl.heightForLabel()
        
        self.getUserPhoto()
        
    }
    
    //Mark :- Get User Photo Api
    
    func getUserPhoto() {
    
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)
 
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
            
//        let strUrl = APINAME.init().get_user_photo
        let strUrl = IDENTITY_BASE_URL + "/v1/profile/photo"
        
        var request = URLRequest(url: NSURL(string: strUrl)! as URL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
        print(strUrl)
        WebService.authenticationFunction()
            
            AF.request(request)
                .response { (response) in
                    print(response.response?.statusCode)
                   let statusCode = response.response?.statusCode
                    if (statusCode == 404) || (strUrl.contains("logout") && statusCode == 200) || (statusCode == 204) {
                        self.profileImageView.image = UIImage.init()
                        SVProgressHUD.dismiss()
                       return
                    }
                    
                    if statusCode == 200 {
        
                    if let data = response.data {
                        self.profileImageView.image = UIImage(data: data)!
                      }
                        
                    }
                    else {
                        self.profileImageView.image = UIImage.init()
                    }
                   
                }
                .responseString { response in
                    print(response)
                    // do whatever you want here
                    switch response.result {
                    case .success(_):
                        if let data = response.data
                        {
                            print(JSON(data))
                            SVProgressHUD.dismiss()
                            
                            let res = JSON(data)
//                            if res == nil {
//                                NotificationCenter.default.post(name: NSNotification.Name.init("LogoutNotification"), object: nil)
//                            }
                            
                            if let dataDictionary = JSON(data).dictionaryObject
                            {
                                    print(dataDictionary)
                            }
                            if let dataArray = JSON(data).arrayObject
                            {
                               print(dataArray)
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
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        self.fetchRedirectUrl(authUrl: self.authUrl)
    }
    
    
    @IBAction func dataSharingButton(_ sender: UIButton) {
        if self.dataSharingInfoView.isHidden {
            self.dataSharingInfoView.isHidden = false
            self.dataSharingInfoViewHeightConstraint.constant = 100
        }
        else {
            self.dataSharingInfoView.isHidden = true
            self.dataSharingInfoViewHeightConstraint.constant = 0
        }
        
    }
    
    @IBAction func secureConnectionButton(_ sender: UIButton) {
        if self.secureConnectionInfoView.isHidden {
            self.secureConnectionInfoView.isHidden = false
            self.secureConnectionInfoViewHeightConstraint.constant = 120
        }
        else {
            self.secureConnectionInfoView.isHidden = true
            self.secureConnectionInfoViewHeightConstraint.constant = 0
        }
    }
    
    @IBAction func fcaAuthorisationButton(_ sender: UIButton) {
        if self.fcaAuthorisationInfoView.isHidden {
            self.fcaAuthorisationInfoView.isHidden = false
            self.fcaAuthorisationInfoViewHeightConstraint.constant = 165
        }
        else {
            self.fcaAuthorisationInfoView.isHidden = true
            self.fcaAuthorisationInfoViewHeightConstraint.constant = 0
        }
    }
    
    @IBAction func allowTheAcessButton(_ sender: UIButton) {
        if self.allowTheAccessInfoView.isHidden {
            self.allowTheAccessInfoView.isHidden = false
            self.allowTheAccessInfoViewHeightConstraint.constant = 205
        }
        else {
            self.allowTheAccessInfoView.isHidden = true
            self.allowTheAccessInfoViewHeightConstraint.constant = 0
        }
    }
    
    func fetchRedirectUrl(authUrl: String) {
        SVProgressHUD.show()
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
                                self.dismiss(animated: true, completion: nil)
                                self.cantFetchAccountsDelegate.cantFetchAccounts(msg: ((errors as! [NSDictionary])[0] ).value(forKey: "message") as! String)
//                                COMMON_FUNCTIONS.showAlert(msg: ((errors as! [NSDictionary])[0] ).value(forKey: "message") as! String)
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
