//
//  ReceiptDetailViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 19/02/21.
//

import UIKit
import SDWebImage
//import FacebookLogin
//import FacebookShare


class ReceiptDetailViewController: UIViewController , ManualAndTutorialsDelegate , UIGestureRecognizerDelegate{

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var merchantCompanyLogo: UIImageView!

    var dataDict = NSDictionary.init()
    var accountId = ""
    var retailerTransactionId = ""
    
    var dataArray = [String:Any]()
    var promotionDict = NSDictionary.init()
    var merchantDict = NSDictionary.init()
    var blogsArray = [NSDictionary]()
    var brandColor = ""
    
    @IBOutlet weak var promotionTableHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.merchantCompanyLogo.layer.borderColor = UIColor.black.cgColor
//        self.merchantCompanyLogo.layer.borderWidth = 1
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.tableV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableV.frame.width, height: 20))
        
        self.callApi()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
    // Set Fields
    func setFields() {
        
        if let date = dataDict["date"] {
            self.dateLbl.text = (date as! String)
        }
    
        if let time = dataDict["time"] {
            self.timeLbl.text = (time as! String)
        }
        
        if let brandColor = dataDict["brandColour"] {
            if (brandColor  as? String) != nil {
            self.brandColor = brandColor as! String
            }
        }
       
        if let promotionDict = dataDict["promotion"] {
            if (promotionDict as? NSDictionary) != nil {
            self.promotionDict = promotionDict as! NSDictionary
            }
          
        }
        if let merchantDict = dataDict["merchant"] {
            if (merchantDict as? NSDictionary) != nil {
                self.merchantDict = merchantDict as! NSDictionary

                if let logo = (merchantDict as! NSDictionary).value(forKey: "logo") {
                    self.merchantCompanyLogo.image = UIImage(named: logo as! String)
                }
                else {
                    self.merchantCompanyLogo.image = #imageLiteral(resourceName: "placeholder")
                }
                
//            let merchantCompanyLogoUrl = URL(string: ((merchantDict as! NSDictionary).value(forKey: "companyLogoUrl") as! String))
//            self.merchantCompanyLogo.sd_setImage(with: merchantCompanyLogoUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
            }
        }
        
        if let blogsArray = dataDict["blogs"] {
            if (blogsArray as? [NSDictionary]) != nil {
                self.blogsArray = blogsArray as! [NSDictionary]
            }
        }
        if let productsArray = dataDict["products"] {
            if (productsArray as? [NSDictionary]) != nil {
            var newProductArray = [NSDictionary]()
            for (index,item) in (productsArray as! [NSDictionary]).enumerated() {
                let mutableDict = item.mutableCopy() as! NSMutableDictionary
                if index == 0 {
                    mutableDict.setValue("1", forKey: "isSelected")
                }
                else {
                mutableDict.setValue("0", forKey: "isSelected")
                }
//                let promotionImageUrl = URL(string: (mutableDict.value(forKey: "imageUrl") as! String))
//              let imageHeight = calculateHeight(url: promotionImageUrl!)
//                mutableDict.setValue(imageHeight, forKey: "image_height")
                newProductArray.append(mutableDict)
            }
            
            dataArray["products"] = newProductArray
            }
        }

        print(dataArray)
        
//        self.promotionItemHeightConstraint.constant = self.promotionItem.heightForLabel()
//        self.promotionDescriptionHeightConstraint.constant = self.promotionDescription.heightForLabel()
//        self.merchantWebsiteUrlLblHeightContraint.constant = self.merchantWebsiteUrl.heightForLabel()
        
        DispatchQueue.main.async {
            self.tableV.reloadData()
        }
    }
     
    //Mark :- Call Transactions Api
    
    func callApi()  {
        
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
            self.dataDict = response
            self.setFields()
        } failure: { (error) in
            print(error)
        }
    }
    func goToManualAndTutorials() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManualsAndTutorialsViewController") as! ManualsAndTutorialsViewController
        if merchantDict.count > 0 {
            vc.merchantLogo = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "companyLogoUrl") as AnyObject).1
            vc.merchantName = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "name") as AnyObject).1
            vc.companyUrl = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "websiteUrl") as AnyObject).1
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ReceiptDetailViewController : UITableViewDataSource , UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        if promotionDict.count > 0 {
            return  self.dataArray.count + 2
        }
        return self.dataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if promotionDict.count > 0 {
            if section == 1 && dataArray.count > 0{
                return (dataArray["products"] as! [NSDictionary]).count
            }
            return 1
        }
        else {
            if section == 0 && dataArray.count > 0 {
           return (dataArray["products"] as! [NSDictionary]).count
        }
        return 1
      }
    }
    
    func calculateHeight(url: URL) -> CGFloat {
     
            // Image Height Calculation
            let imageData = try! Data(contentsOf: url)
         let image = UIImage(data: imageData)
         let originalHeight = (image?.size.height)!
         let originalWidth = (image?.size.width)!
         let newHeight = (originalHeight/originalWidth)*(110.0)
   
        return newHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if promotionDict.count > 0 {
            if indexPath.section == 0 {
                let nib = UINib(nibName: "PromotionsTableViewCell", bundle: nil)
                self.tableV.register(nib, forCellReuseIdentifier: "PromotionsTableViewCell")
                let cell = tableV.dequeueReusableCell(withIdentifier: "PromotionsTableViewCell") as! PromotionsTableViewCell
                
                if promotionDict.count > 0 {
                    cell.promotionItem.text = (promotionDict.value(forKey: "item") as! String)
                    cell.promotionItemHeightConstraint.constant = cell.promotionItem.heightForLabel()
                    cell.promotionDescription.text = (promotionDict.value(forKey: "description") as! String)
//                    cell.promotionDescriptionHeightConstraint.constant = cell.promotionDescription.heightForLabel()
                let promotionImageUrl = URL(string: (promotionDict.value(forKey: "imageUrl") as! String))
                    cell.promotionImage.sd_setImage(with: promotionImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
                let promotionButtonText = (promotionDict.value(forKey: "buttonText") as! String)
                    cell.promotionButton.setTitle(promotionButtonText, for: .normal)
                }
                
                if merchantDict.count > 0 {
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                    var webUrl = (merchantDict.value(forKey: "websiteUrl") as! String)
                    webUrl = webUrl.replacingOccurrences(of: "https://www.", with: "")
                    webUrl = webUrl.replacingOccurrences(of: "https://", with: "")
                   print(webUrl)
                let underlineAttributedString = NSAttributedString(string: webUrl, attributes: underlineAttribute)
                cell.merchantWebsiteUrl.attributedText = underlineAttributedString
                    cell.merchantWebsiteUrl.textColor = hexStringToUIColor(hex: self.brandColor)
                }
                
                cell.merchantWebsiteUrlButton.addTarget(self, action: #selector(merchantWebsiteUrlButton(_:)), for: .touchUpInside)
                cell.promotionButton.addTarget(self, action: #selector(promotionButton(_:)), for: .touchUpInside)
          
                return cell
            }
            else if indexPath.section == 1 {
                let nib = UINib(nibName: "ItemsTableViewCell", bundle: nil)
                self.tableV.register(nib, forCellReuseIdentifier: "ItemsTableViewCell")
                let cell = tableV.dequeueReusableCell(withIdentifier: "ItemsTableViewCell") as! ItemsTableViewCell
                let productsArray = dataArray["products"] as! [NSDictionary]
                let dict = productsArray[indexPath.row]
                cell.productItem.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "item") as AnyObject).1
                /*cell.productItemHeightConstraint.constant = cell.productItem.heightForLabel()*/
           
                cell.productDescription.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1
                cell.productDescriptionTextView.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1 
                let promotionImgUrl = URL(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "imageUrl") as AnyObject).1)
      
                cell.productImage.sd_setImage(with: promotionImgUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
                cell.productQuantity.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "quantity") as AnyObject).1
                let currencySymbol = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "currencySymbol") as AnyObject).1
//                if let amount = dict.value(forKey: "amount") {
//                cell.productAmount.text = currencySymbol + "\(amount as! NSNumber)"
//                }
//                else {
//                    cell.productAmount.text = ""
//                }
                cell.productAmount.text = currencySymbol + COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "amountTotal") as AnyObject).1
       
                let dateTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "warrantyExpiryDateTime") as AnyObject).1
                cell.productWarrantyExpiryDateTime.text = dateTime
                
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let underlineAttributedString = NSAttributedString(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "warrantyText") as AnyObject).1, attributes: underlineAttribute)
//                cell.twoYearsWarrantyLbl.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "warrantyText") as AnyObject).1
                cell.twoYearsWarrantyLbl.attributedText = underlineAttributedString
                cell.twoYearsWarrantyLbl.textColor = hexStringToUIColor(hex: self.brandColor)
                if dateTime == "" {
                    cell.expiresLbl.isHidden = true
                    cell.twoYearsWarrantyLbl.isHidden = true
                    cell.productWarrantyLblConstraint.constant = 0.0
                    cell.expiresLblConstraint.constant = 0.0
                    cell.twoYearsHeightConstraint.constant = 0.0
                }
                else {
                    cell.expiresLbl.isHidden = false
                    cell.twoYearsWarrantyLbl.isHidden = false
                    cell.productWarrantyLblConstraint.constant = 18.0
                    cell.expiresLblConstraint.constant = 18.0
                    cell.twoYearsHeightConstraint.constant = 18.0
                }
//                cell.productDescriptionHeightConstraint.constant = cell.productDescription.heightForLabel()
                
                
                if indexPath.row == 0 {
                    cell.itemheaderViewHeightConstraint.constant = 50.0
                }
                else {
                    cell.itemheaderViewHeightConstraint.constant = 0.0
                }
                
                if dict.value(forKey: "isSelected") as! String == "0" {
                    cell.itemLongViewHeightConstraint.constant = 0.0
                    cell.itemFullView.isHidden = true
                    cell.expandImage.image = #imageLiteral(resourceName: "expand")
                }
                else {
                    if dateTime == "" {
                        cell.rateMeViewTopConstraint.constant = 29.0
                        cell.itemLongViewHeightConstraint.constant = 117.0
                        cell.productDescriptionTextViewHeightConstraint.constant = 100
                    }
                    else {
                        cell.rateMeViewTopConstraint.constant = 39.0
                        cell.itemLongViewHeightConstraint.constant = 127.0 + 10.0
                        cell.productDescriptionTextViewHeightConstraint.constant = 50
                    }
                    cell.itemFullView.isHidden = false
                    cell.expandImage.image = #imageLiteral(resourceName: "collapse")
                }
       
                cell.expandViewToggleButton.tag = indexPath.row
                cell.expandViewToggleButton.addTarget(self, action: #selector(toggleItemView(_:)), for: .touchUpInside)
                
                cell.moreButton.tag = indexPath.row
                cell.moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
                
                cell.shareButton.tag = indexPath.row
                cell.shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
            
            else {
                let nib = UINib(nibName: "BlogsTableViewCell", bundle: nil)
                self.tableV.register(nib, forCellReuseIdentifier: "BlogsTableViewCell")
                let cell = tableV.dequeueReusableCell(withIdentifier: "BlogsTableViewCell") as! BlogsTableViewCell
                var dict = NSDictionary.init()
                if self.blogsArray.count > 0 {
                    for (index,item) in self.blogsArray.enumerated() {
                    dict = item
                    if index == 0 {
                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                        let underlineAttributedString = NSAttributedString(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1, attributes: underlineAttribute)
                        cell.blogsDescription.attributedText = underlineAttributedString
                    }
                    else {
                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                        let underlineAttributedString = NSAttributedString(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1, attributes: underlineAttribute)
                        cell.blogsDescription2.attributedText = underlineAttributedString
     
                    }
                }
                    cell.blogsDescription.textColor = hexStringToUIColor(hex: self.brandColor)
                    cell.blogsDescription2.textColor = hexStringToUIColor(hex: self.brandColor)
                    cell.blogDescriptionHeightConstraint.constant = cell.blogsDescription.heightForLabel()
                    cell.blogDescription2HeightConstraint.constant = cell.blogsDescription2.heightForLabel()
                }
                else {
                    cell.blogsDescription.text = ""
                    cell.blogsDescription2.text = ""
                }
                
                let currencySymbol = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "currencySymbol") as AnyObject).1
                let vat = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "vat") as AnyObject).1
//                cell.vatValue.text = currencySymbol + COMMON_FUNCTIONS.getCorrectPriceFormat(price: vat)
                cell.vatValue.text = currencySymbol + vat
                let total = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "total") as AnyObject).1
//                cell.totalValue.text = currencySymbol + COMMON_FUNCTIONS.getCorrectPriceFormat(price: total)
                cell.totalValue.text = currencySymbol + total
                cell.posProvider.text = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "posProvider") as AnyObject).1
              
                cell.blogUrlButton.tag = 0
                cell.blogUrlButton.addTarget(self, action: #selector(goToBlogsUrl(_:)), for: .touchUpInside)
                
                cell.blogUrl2Button.tag = 1
                cell.blogUrl2Button.addTarget(self, action: #selector(goToBlogsUrl(_:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
        }
        
        else {
            if indexPath.section == 0 && dataArray.count > 0 {
            let nib = UINib(nibName: "ItemsTableViewCell", bundle: nil)
            self.tableV.register(nib, forCellReuseIdentifier: "ItemsTableViewCell")
            let cell = tableV.dequeueReusableCell(withIdentifier: "ItemsTableViewCell") as! ItemsTableViewCell
            let productsArray = dataArray["products"] as! [NSDictionary]
            let dict = productsArray[indexPath.row]
            cell.productItem.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "item") as AnyObject).1
            /*cell.productItemHeightConstraint.constant = cell.productItem.heightForLabel()*/
       
            cell.productDescription.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1
                cell.productDescriptionTextView.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1
            let promotionImgUrl = URL(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "imageUrl") as AnyObject).1)
         
            cell.productImage.sd_setImage(with: promotionImgUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
            cell.productQuantity.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "quantity") as AnyObject).1
            let currencySymbol = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "currencySymbol") as AnyObject).1
//            if let amount = dict.value(forKey: "amount") {
//            cell.productAmount.text = currencySymbol + "\(amount as! NSNumber)"
//            }
//            else {
//                cell.productAmount.text = ""
//            }
                cell.productAmount.text = currencySymbol + COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "amount") as AnyObject).1

            let dateTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "warrantyExpiryDateTime") as AnyObject).1
            cell.productWarrantyExpiryDateTime.text = dateTime
            
                cell.productWarrantyExpiryDateTime.textColor = hexStringToUIColor(hex: self.brandColor)
            
            if dateTime == "" {
                cell.expiresLbl.isHidden = true
                cell.twoYearsWarrantyLbl.isHidden = true
                cell.productWarrantyLblConstraint.constant = 0.0
                cell.expiresLblConstraint.constant = 0.0
                cell.twoYearsHeightConstraint.constant = 0.0
            }
            else {
                cell.expiresLbl.isHidden = false
                cell.twoYearsWarrantyLbl.isHidden = false
                cell.productWarrantyLblConstraint.constant = 18.0
                cell.expiresLblConstraint.constant = 18.0
                cell.twoYearsHeightConstraint.constant = 18.0
            }
 
//            cell.productDescriptionHeightConstraint.constant = cell.productDescription.heightForLabel()
            
            if indexPath.row == 0 {
                cell.itemheaderViewHeightConstraint.constant = 50.0
            }
            else {
                cell.itemheaderViewHeightConstraint.constant = 0.0
            }
            
            if dict.value(forKey: "isSelected") as! String == "0" {
                cell.itemLongViewHeightConstraint.constant = 0.0
                cell.itemFullView.isHidden = true
                cell.expandImage.image = #imageLiteral(resourceName: "expand")
            }
            else {
                if dateTime == "" {
                    cell.rateMeViewTopConstraint.constant = 29.0
                    cell.itemLongViewHeightConstraint.constant = 117.0
                    cell.productDescriptionTextViewHeightConstraint.constant = 100
                }
                else {
                    cell.rateMeViewTopConstraint.constant = 39.0
                cell.itemLongViewHeightConstraint.constant = 120.0 + 10.0
                    cell.productDescriptionTextViewHeightConstraint.constant = 50
                }
                cell.itemFullView.isHidden = false
                cell.expandImage.image = #imageLiteral(resourceName: "collapse")
            }
            
            cell.expandViewToggleButton.tag = indexPath.row
            cell.expandViewToggleButton.addTarget(self, action: #selector(toggleItemView(_:)), for: .touchUpInside)
                
            cell.moreButton.tag = indexPath.row
            cell.moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
            cell.shareButton.tag = indexPath.row
            cell.shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
                
            cell.selectionStyle = .none
            return cell
        }
        
        else {
            let nib = UINib(nibName: "BlogsTableViewCell", bundle: nil)
            self.tableV.register(nib, forCellReuseIdentifier: "BlogsTableViewCell")
            let cell = tableV.dequeueReusableCell(withIdentifier: "BlogsTableViewCell") as! BlogsTableViewCell
            var dict = NSDictionary.init()
            if blogsArray.count > 0 {
                for (index,item) in blogsArray.enumerated() {
                dict = item
                if index == 0 {
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                    let underlineAttributedString = NSAttributedString(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1, attributes: underlineAttribute)
                    cell.blogsDescription.attributedText = underlineAttributedString
     
                }
                else {
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                    let underlineAttributedString = NSAttributedString(string: COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "description") as AnyObject).1, attributes: underlineAttribute)
                    cell.blogsDescription2.attributedText = underlineAttributedString

                }
            }
                cell.blogsDescription.textColor = hexStringToUIColor(hex: self.brandColor)
                cell.blogsDescription2.textColor = hexStringToUIColor(hex: self.brandColor)
                cell.blogDescriptionHeightConstraint.constant = cell.blogsDescription.heightForLabel()
                cell.blogDescription2HeightConstraint.constant = cell.blogsDescription2.heightForLabel()
            }
            else {
                cell.blogsDescription.text = ""
                cell.blogsDescription2.text = ""
            }
            
            let currencySymbol = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "currencySymbol") as AnyObject).1
            let vat = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "vat") as AnyObject).1
//            cell.vatValue.text = currencySymbol + COMMON_FUNCTIONS.getCorrectPriceFormat(price: vat)
            cell.vatValue.text = currencySymbol + vat
            let total = COMMON_FUNCTIONS.checkForNull(string: dataDict.value(forKey: "total") as AnyObject).1
//            cell.totalValue.text = currencySymbol + COMMON_FUNCTIONS.getCorrectPriceFormat(price: total)
            cell.totalValue.text = currencySymbol + total
            if dataDict.count > 0 {
            cell.posProvider.text = (dataDict.value(forKey: "posProvider") as! String)
            }
            cell.blogUrlButton.tag = 0
            cell.blogUrlButton.addTarget(self, action: #selector(goToBlogsUrl(_:)), for: .touchUpInside)
            
            cell.blogUrl2Button.tag = 1
            cell.blogUrl2Button.addTarget(self, action: #selector(goToBlogsUrl(_:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
        }
        
    }
    
    @objc func moreButtonTapped(_ sender:UIButton) {
        let productsArray = dataArray["products"] as! [NSDictionary]
        let dict = productsArray[sender.tag]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActionSheetViewController") as! ActionSheetViewController
        vc.itemDict = dict
        vc.productItem = dict.value(forKey: "item") as! String
        vc.merchantDict = self.merchantDict
        vc.manualAndTutorialsDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
       
    
    @objc func merchantWebsiteUrlButton(_ sender: UIButton) {
        var urlStr = ""
        if dataDict.count > 0 {
            if let merchantDict = dataDict["merchant"] {
                if (merchantDict as? NSDictionary) != nil {
                urlStr = ((merchantDict as! NSDictionary).value(forKey: "websiteUrl") as! String)
                }
            }
        }
        guard let url = URL(string: urlStr) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
        else {
            COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + urlStr, title: "")
        }

    }
    
    @objc func promotionButton(_ sender: UIButton) {
        var urlStr = ""
        if dataDict.count > 0 {
            if let promotionDict = dataDict["promotion"] {
                if (promotionDict as? NSDictionary) != nil {
                urlStr = ((promotionDict as! NSDictionary).value(forKey: "buttonUrl") as! String)
                }
            }
        }
        guard let url = URL(string: urlStr) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
        else {
            COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + urlStr, title: "")
        }
    }
 
    @objc func toggleItemView(_ sender : UIButton) {
        var productsArray = dataArray["products"] as! [NSDictionary]
        for (index,item) in (productsArray).enumerated() {
            if item == productsArray[sender.tag] {
                let dict = item.mutableCopy() as! NSMutableDictionary
                print(item)
                if item.value(forKey: "isSelected") as! String == "1" {
                dict.setValue("0", forKey: "isSelected")
                }
                else {
                    dict.setValue("1", forKey: "isSelected")
                }
                productsArray[index] = dict
            }
        }
        self.dataArray["products"] = productsArray
        DispatchQueue.main.async {
            self.tableV.reloadData()
        }
    }
    
    @objc func goToBlogsUrl(_ sender : UIButton) {
        if self.blogsArray.count > 0 {
        
        let urlStr = (self.blogsArray[sender.tag]).value(forKey: "url") as! String
        print(urlStr)
        guard let url = URL(string: urlStr) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
        else {
            COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + urlStr, title: "")
        }
        }
    }
    
    @objc func shareButtonTapped(_ sender : UIButton) {
        let productsArray = dataArray["products"] as! [NSDictionary]
        let dict = productsArray[sender.tag]
        print(dict)
//        if let token = AccessToken.current {
//            print("FB Access Token:\(token)")
//            let image = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "imageUrl") as AnyObject).1
//              let merchantName = COMMON_FUNCTIONS.checkForNull(string: self.merchantDict.value(forKey: "name") as AnyObject).1
//              let productItem = COMMON_FUNCTIONS.checkForNull(string: self.merchantDict.value(forKey: "item") as AnyObject).1
//              let detailStr = "I just made a purchase from \(merchantName)!\n\(productItem)"
//
//              let photo:SharePhoto = SharePhoto()
//              let myContent = SharePhotoContent()
//
//              let imageView = UIImageView()
//              imageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
//              photo.caption = detailStr
//              photo.image = imageView.image
//              photo.isUserGenerated = true
//              print(detailStr)
//              myContent.photos = [photo]
//              let dialog = ShareDialog(fromViewController: self, content: myContent, delegate: self)
//              dialog.mode = .browser
//                dialog.show()
//
//        }
//        else {
//            let manager = LoginManager()
//            manager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
//                if error != nil {
//                    print(error?.localizedDescription)
//                    return
//                }
//                let image = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "imageUrl") as AnyObject).1
//                  let merchantName = COMMON_FUNCTIONS.checkForNull(string: self.merchantDict.value(forKey: "name") as AnyObject).1
//                  let productItem = COMMON_FUNCTIONS.checkForNull(string: self.merchantDict.value(forKey: "item") as AnyObject).1
//                  let detailStr = "I just made a purchase from \(merchantName)!\n\(productItem)"
//
//                  let photo:SharePhoto = SharePhoto()
//                  let myContent = SharePhotoContent()
//
//                  let imageView = UIImageView()
//                  imageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
//                  photo.caption = detailStr
//                  photo.image = imageView.image
//                  photo.isUserGenerated = true
//                  print(detailStr)
//                  myContent.photos = [photo]
//                  let dialog = ShareDialog(fromViewController: self, content: myContent, delegate: self)
//                  dialog.mode = .browser
//                    dialog.show()
//
//            }
//        }
   }

//    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
//        print(results)
//    }
//
//    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
//        print(error)
//    }
//
//    func sharerDidCancel(_ sharer: Sharing) {
//        print(sharer)
//    }

}
