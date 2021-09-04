//
//  NonAirslipPartnerViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 17/02/21.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NonAirslipPartnerViewController: UIViewController , ReceivingAirslipsSuccess , UIGestureRecognizerDelegate{
 
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var merchantLogo: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var comingSoonView: UIView!
    @IBOutlet weak var descriptionOneLbl: UILabel!
    @IBOutlet weak var descriptionTwoLbl: UILabel!
    @IBOutlet weak var yesButtonView: UIView!
    @IBOutlet weak var noButtonView: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var descriptionOneTextView: UITextView!
    @IBOutlet weak var descriptionTwoTextView: UITextView!
    @IBOutlet weak var descriptionLblHeightConstraint: NSLayoutConstraint!
    
    var merchantNameStr = ""
    var merchantLogoStr = ""
    var dateStr = ""
    var timeStr = ""
    var amountStr = ""
    var accountId = ""
    var retailerTransactionId = ""
    var merchantDict = NSDictionary.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        getTransactionDetail()
        print(merchantDict)
        self.merchantNameStr = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "name") as AnyObject).1
        self.merchantLogoStr = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "logo") as AnyObject).1
        
        self.amountLbl.text = self.amountStr
        
        let descriptionTextOne = "Unfortunately, \(merchantNameStr) hasn't integrated with Airslip just yet."
        self.descriptionOneLbl.attributedText = descriptionTextOne.withBoldText(text: merchantNameStr)
        self.descriptionOneTextView.attributedText = descriptionTextOne.withBoldText(text: merchantNameStr)
        
        let descriptionTextTwo = "Do you want to see your \(merchantNameStr) receipts on Airslip?"
        self.descriptionTwoLbl.attributedText = descriptionTextTwo.withBoldText(text: merchantNameStr)
        self.descriptionTwoTextView.attributedText = descriptionTextTwo.withBoldText(text: merchantNameStr)
        
        self.yesButton.layer.cornerRadius = 7
        self.yesButton.layer.masksToBounds = true
        
        // Merchant Image
        var imageUrl : URL!
        imageUrl = URL(string: self.merchantLogoStr)
        self.dateLbl.text = self.dateStr
        self.timeLbl.text = self.timeStr
    }
    
    func setData(merchantDict:NSDictionary) {
        print(merchantDict)
        
        self.merchantNameStr = COMMON_FUNCTIONS.checkForNull(string: (merchantDict.value(forKey: "merchant") as! NSDictionary).value(forKey: "name") as AnyObject).1
        self.merchantLogoStr = COMMON_FUNCTIONS.checkForNull(string: (merchantDict.value(forKey: "merchant") as! NSDictionary).value(forKey: "logo") as AnyObject).1
        
        self.descriptionLbl.text = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "description") as AnyObject).1
        
        print(self.merchantLogoStr)
        // Merchant Logo
        self.merchantLogo.image = self.merchantLogoStr != "" ? UIImage(named: self.merchantLogoStr) : #imageLiteral(resourceName: "placeholder")
        let descriptionTextOne = "Unfortunately, \(merchantNameStr) hasn't integrated with Airslip just yet."
        self.descriptionOneLbl.attributedText = descriptionTextOne.withBoldText(text: merchantNameStr)
        
        let descriptionTextTwo = "Do you want to see your \(merchantNameStr) receipts on Airslip?"
        self.descriptionTwoLbl.attributedText = descriptionTextTwo.withBoldText(text: merchantNameStr)
        self.descriptionLblHeightConstraint.constant = self.descriptionLbl.heightForLabel()
    }
    
    override func viewDidLayoutSubviews() {
        
        self.comingSoonView.layer.cornerRadius = 10.0
        self.comingSoonView.layer.masksToBounds = false
        self.comingSoonView.layer.backgroundColor = UIColor.white.cgColor
        self.comingSoonView.layer.shadowColor = UIColor.darkGray.cgColor
        self.comingSoonView.layer.shadowOffset = .zero
        self.comingSoonView.layer.shadowRadius = 3.0
        self.comingSoonView.layer.shadowOpacity = 0.2
        self.comingSoonView.layer.masksToBounds = false
        self.comingSoonView.layer.shadowPath = UIBezierPath(roundedRect:self.comingSoonView.bounds, cornerRadius:self.comingSoonView.layer.cornerRadius).cgPath
        
        
        self.yesButtonView.layer.cornerRadius = self.yesButtonView.frame.height / 2
        self.yesButtonView.layer.masksToBounds = false
        self.yesButtonView.layer.backgroundColor = hexStringToUIColor(hex: "#2584B6").cgColor
        self.yesButtonView.layer.shadowColor = UIColor.darkGray.cgColor
        self.yesButtonView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        self.yesButtonView.layer.shadowRadius = 5.0
        self.yesButtonView.layer.shadowOpacity = 0.7
        self.yesButtonView.layer.masksToBounds = false
        
        self.noButtonView.layer.cornerRadius = self.noButtonView.frame.height / 2
        self.noButtonView.layer.masksToBounds = false
        self.noButtonView.layer.backgroundColor = UIColor.white.cgColor
        self.noButtonView.layer.shadowColor = UIColor.darkGray.cgColor
        self.noButtonView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        self.noButtonView.layer.shadowRadius = 5.0
        self.noButtonView.layer.shadowOpacity = 0.7
        self.noButtonView.layer.masksToBounds = false
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        self.callApi(type: "true")
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        self.callApi(type: "false")
    }
    
    func getTransactionDetail() {
        let api_name = APINAME.init().accounts + "/\(accountId)" + "/transactions/" + retailerTransactionId
        WebService.requestGetUrl(strURL: api_name, params: [:], is_loader_required: true) { (response) in
            print(response)
            if let error = response["errorCode"] {
                var reauthoriseLink = ""
                if let linksArray = response["_links"] {
                    for item in (linksArray as! [NSDictionary]) {
                        if item.value(forKey: "rel") as! String == "next" {
                            reauthoriseLink = item.value(forKey: "href") as! String
                        }
                    }
                }

                print(error)
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReAuthoriseViewController") as! ReAuthoriseViewController
                vc.titleText = response["message"] as! String
                vc.authUrl = reauthoriseLink
                vc.isFromAccountsTransactionPage = true
                self.present(vc, animated: true, completion: nil)
            }
            
            if let errorMessage = response["errorMessage"] {
                COMMON_FUNCTIONS.showAlert(msg: errorMessage as! String, title: "")
                return
            }
            
            if let merchant = response["merchant"] {
                print(merchant)
                self.setData(merchantDict: response)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    
    
    // Mark:- Call Api
    
    func callApi(type:String) {
        let merchant_name = merchantNameStr.replacingOccurrences(of: " ", with: "")
        let api_name = APINAME.init().unsupported_merchants + "/\(merchant_name)" + "/unsupported?inDemand=\(type)"
 
        SVProgressHUD.show()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(BASE_URL.appending(api_name))
        WebService.authenticationFunction()
        
        
        AF.request(BASE_URL.appending(api_name), method: HTTPMethod.post, parameters: Parameters.init(), encoding: JSONEncoding.default, headers: headers)
            .response { (response) in
                print(response)
                print(response.response?.statusCode)
               let statusCode = response.response?.statusCode
                if (statusCode == 204) {
                    SVProgressHUD.dismiss()
                    if type == "false" {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReAuthoriseViewController") as! ReAuthoriseViewController
                    vc.titleText = "Thanks!\nWe will let the guys know at \(self.merchantNameStr) that you would like to start receiving Airslips."
                     vc.isFromAccountsTransactionPage = false
                     vc.receivingAirslipsSuccess = self
                     self.present(vc, animated: true, completion: nil)
                }
                else {
                    SVProgressHUD.dismiss()
                    COMMON_FUNCTIONS.showAlert(msg: "SERVER ERROR", title: "")
                }
            }
    }
    
    func alislipsSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
 
}
