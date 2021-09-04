//
//  HomeViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 11/02/21.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class HomeViewController: UIViewController , UIGestureRecognizerDelegate {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var selectedCountryLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var banksCollectionView: UICollectionView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var countryView: UIView!
    
    @IBOutlet weak var chooseCountryView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var expandIcon: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
  
    var searchStr = ""
    var banks = [NSDictionary]()
    var countriesArray = NSMutableArray.init()
    
    var refreshControl = UIRefreshControl()
    var isFromManageVC = false
    
    var estimateWidth = 160.0
    var cellMarginSize = 8.0
    
    let alertService = AlertService()
    
    @IBOutlet weak var descriptionLblHeightConst: NSLayoutConstraint!
   
    @IBOutlet weak var searchView: UIView!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled =  isFromManageVC ? true : false

        
        if !isFromManageVC {
            if isNewUser {
                self.isNewUserPopup()
            }
        }
        
        self.backButton.isHidden = isFromManageVC ? false : true
        self.searchButton.setImage( #imageLiteral(resourceName: "search-icon-grey"), for: .normal)
        self.searchTextField.delegate = self
        
        self.setUpGridView()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        banksCollectionView.addSubview(refreshControl)
        self.chooseCountryView.isHidden = true
        self.countryTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 5))
        self.countryTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 5))
        self.callApi(CountryCode: "GB")
        let dic1:NSDictionary = NSDictionary(dictionaryLiteral: ("value","FR"),("title","France"),("isSelected","0"))
        let dic2:NSDictionary = NSDictionary(dictionaryLiteral: ("value","IE"),("title","Ireland"),("isSelected","0"))
        let dic3:NSDictionary = NSDictionary(dictionaryLiteral: ("value","NL"),("title","Netherlands"),("isSelected","0"))
        let dic4:NSDictionary = NSDictionary(dictionaryLiteral: ("value","GB"),("title","United Kingdom"),("isSelected","1"))
        countriesArray = NSMutableArray(objects: dic1,dic2,dic3,dic4)
 
        SHADOW_EFFECT.makeBottomShadow(forView: self.chooseCountryView,top_shadow: true)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        descriptionLbl.addGestureRecognizer(tap1)
        topView.addGestureRecognizer(tap2)
        countryView.addGestureRecognizer(tap3)
//        banksCollectionView.addGestureRecognizer(tap4)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.descriptionLblHeightConst.constant = self.descriptionLbl.heightForLabel()
        
        self.searchView.layer.borderColor = hexStringToUIColor(hex: LIGHT_BORDER_COLOR).cgColor
        self.searchView.layer.borderWidth = 1
        self.searchView.layer.cornerRadius = 7
        
        self.setUpGridView()
        DispatchQueue.main.async {
            self.banksCollectionView.reloadData()
        }
    }
    
    func setUpGridView() {
       let flow = self.banksCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(cellMarginSize)
        flow.minimumLineSpacing = CGFloat(cellMarginSize)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.searchTextField.text = ""
        self.searchStr = ""
        
        var country_code = ""
        for item in self.countriesArray {
            let dict = (item as! NSDictionary)
            if dict.value(forKey: "isSelected") as! String == "1" {
                country_code = dict.value(forKey: "value") as! String
            }
        }
        self.callApi(CountryCode: country_code)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.chooseCountryView.isHidden = true
    }
    
    func isNewUserPopup() {
        let alertTitle = """
        Do you want to allow \"Airslip\" to use Face ID?
        """
        let alertMessage = """
        Use Face ID to authenticate on Airslip.
        """

        let messageAttribute = [ NSAttributedString.Key.font: UIFont(name: REGULAR_FONT, size: 14.0)! ]
        let attributedMessage = NSMutableAttributedString(string: alertMessage, attributes: messageAttribute )
        
        let titleAttribute = [ NSAttributedString.Key.font: UIFont(name: SEMIBOLD, size: 16.0)! ]
        let attributedTitle = NSMutableAttributedString(string: alertTitle, attributes: titleAttribute )
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Don't Allow", style: .default, handler: { (action) in
            isNewUser = false
            biometricOn = false
            COMMON_FUNCTIONS.updateFaceId()
            return
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            isNewUser = true
            biometricOn = true
            COMMON_FUNCTIONS.updateFaceId()
            return
        }))

        self.present(alert, animated: true)
        
        
//      let alertVC = alertService.alert(title: "", message: "", buttonTitle: "OK", attributedMessage: attributedString)
//        present(alertVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
         
            var country_code = ""
            for item in self.countriesArray {
                let dict = (item as! NSDictionary)
                if dict.value(forKey: "isSelected") as! String == "1" {
                    country_code = dict.value(forKey: "value") as! String
                }
            }
            self.callApi(CountryCode: country_code)
    }
    
    @IBAction func selectCountryButton(_ sender: UIButton) {
        if self.chooseCountryView.isHidden {
            self.countryTableView.reloadData()
            self.chooseCountryView.isHidden = false
            self.expandIcon.image = #imageLiteral(resourceName: "collapse")
        }
        else {
            self.chooseCountryView.isHidden = true
            self.expandIcon.image = #imageLiteral(resourceName: "expand")
        }
    }
    
    //MARK :-  Call Banks API
    
    func callApi(CountryCode: String) {

        for item in countriesArray {
           let dataDic = (item as! NSDictionary)
            if CountryCode == dataDic.value(forKey: "value") as! String {
                self.selectedCountryLabel.text = (dataDic.value(forKey: "title") as! String)
            }
        }
        
        WebService.requestGetUrl(strURL: APINAME.init().banks + "/\(CountryCode)?name=\(self.searchStr)", params: [:], is_loader_required: false) { (response) in
            print(response)
            self.banks.removeAll()
            if let banks = response["banks"] {
                self.banks = banks as! [NSDictionary]
            }
            
            DispatchQueue.main.async {
                self.banksCollectionView.reloadData()
                self.countryTableView.reloadData()
                self.chooseCountryView.isHidden = true
            }
        } failure: { (error) in
            print(error)
            COMMON_FUNCTIONS.showAlert(msg: error, title: "")
        }
        
        self.refreshControl.endRefreshing()
    }
    
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = countryTableView.dequeueReusableCell(withIdentifier: "cell")!
        let dict = self.countriesArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = (dict.value(forKey: "title") as! String)
        
        if dict.value(forKey: "isSelected") as! String == "1" {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.semibold)
        }
        else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.countriesArray[indexPath.row] as! NSDictionary
        for (index,item) in self.countriesArray.enumerated() {
            let dataDic = (item as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if dataDic == dict {
                dataDic.setValue("1", forKey: "isSelected")
            }
            else {
                dataDic.setValue("0", forKey: "isSelected")
            }
            self.countriesArray[index] = dataDic
        }
        self.callApi(CountryCode: dict.value(forKey: "value") as! String)
    }
   
}

extension HomeViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    var numberOfTimeCell : CGFloat { if UIDevice.current.userInterfaceIdiom == .pad
    {   return 4    }
    else{  return 2 }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//          let width = (self.view.frame.size.width - 60)/numberOfTimeCell
////        let width =  (self.view.frame.size.width - 10)/numberOfTimeCell
//        return CGSize(width: width, height: 150)
        let cellWidth = (self.banksCollectionView.frame.size.width - 10) / 2
        let width = self.calculateWith()
        return CGSize(width: width , height: 150)
//        return CGSize(width: cellWidth , height: cellWidth-55)
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor((CGFloat(self.view.frame.size.width) / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader :
//            return UICollectionReusableView.init()
//
//        case UICollectionView.elementKindSectionFooter :
//           return UICollectionReusableView.init()
//
//        default :
//           fatalError("Unexpected element kind")
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: self.view.frame.size.width, height: 30)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//         return CGSize(width: self.view.frame.size.width, height: 50)
//    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        self.banksCollectionView.register(UINib(nibName: "BanksCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BanksCollectionReusableView")
        
        if (kind == UICollectionView.elementKindSectionFooter) {
            self.banksCollectionView.register(UINib(nibName: "BanksCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BanksCollectionReusableView")
            
            let footerView = self.banksCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BanksCollectionReusableView", for: indexPath)
            // Customize footerView here
            return footerView
        } else if (kind == UICollectionView.elementKindSectionHeader) {
            self.banksCollectionView.register(UINib(nibName: "BanksCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BanksCollectionReusableView")
            let headerView = self.banksCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BanksCollectionReusableView", for: indexPath)
            // Customize headerView here
            return headerView
        }
        fatalError()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let nib = UINib(nibName: "BanksCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BanksCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BanksCollectionViewCell", for: indexPath) as! BanksCollectionViewCell
        var imageUrl : URL!
        let dict = self.banks[indexPath.row]
        imageUrl = URL(string: dict.value(forKey: "logo") as! String)
//        let name = dict.value(forKey: "name") as! String
//        if (name == "B Bank") || (name == "Allied Irish Bank") || (name == "Cash Plus") || (name == "Halifax") || (name == "Lloyds") || (name == "M&S Bank") || (name == "Ulster Bank (UK)") || (name == "Yorkshire Building Society"){
//            cell.bankImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
//        }
       
//        else {
        if let icon = dict.value(forKey: "logo") {
            cell.bankImage.image = UIImage(named: COMMON_FUNCTIONS.checkForNull(string: icon as AnyObject).1)
        }
        else {
            cell.bankImage.image = #imageLiteral(resourceName: "placeholder")
        }
//        }

        cell.titleLabel.text = (dict.value(forKey: "name") as! String)
        cell.titleLabelHeightConstraint.constant = cell.titleLabel.heightForLabel()
        
        cell.layer.cornerRadius = 10.0
        cell.mainView.layer.cornerRadius = 10.0
        cell.mainView.layer.borderWidth = 1.0
        cell.mainView.layer.borderColor = UIColor.clear.cgColor
        cell.mainView.layer.masksToBounds = false

        cell.mainView.layer.backgroundColor = UIColor.white.cgColor
        cell.mainView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mainView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
//        cell.mainView.layer.shadowOffset = .zero
        cell.mainView.layer.shadowRadius = 5.0
        cell.mainView.layer.shadowOpacity = 0.2
        cell.mainView.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
//        cell.backgroundColor = .clear
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOffset = .zero
                cell.layer.shadowOpacity = 0.2
                cell.layer.shadowRadius = 20
                cell.clipsToBounds = false
                
//        cell.mainView.backgroundColor = MAIN_COLOR
//        cell.mainView.layer.cornerRadius = 10
//        cell.mainView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bankDict = self.banks[indexPath.row]
        if (bankDict.value(forKey: "bankTypes") as! [NSDictionary]).count == 1 {
            let banksArray = (bankDict.value(forKey: "bankTypes") as! [NSDictionary])
        
            let authUrl = ((banksArray[0]).value(forKey: "_links") as! [NSDictionary])[0].value(forKey: "href") as! String
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
            print(bankDict)
            vc.instituteName = COMMON_FUNCTIONS.checkForNull(string: bankDict.value(forKey: "name") as AnyObject).1
            vc.authUrl = authUrl
            vc.cantFetchAccountsDelegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
//           fetchRedirectUrl(authUrl: authUrl)
            return
        }
        else {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountTypeViewController") as! AccountTypeViewController
            print(bankDict)
        vc.bankDict = bankDict
        vc.accountTypeDelegate = self
        self.present(vc, animated: true, completion: nil)
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
                                return
                            }
                            
                           let authorisationURL = ((dataDictionary as NSDictionary)["authorisationUrl"] as! String)
                            guard let url = URL(string: authorisationURL) else {
                                 return
                             }
                            if UIApplication.shared.canOpenURL(url) {
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


extension HomeViewController : UITextFieldDelegate , AccountTypeDelegate, CantFetchAccountsDelegate {
    func cantFetchAccounts(msg: String) {
        COMMON_FUNCTIONS.showAlert(msg: msg, title: "")
    }
    
    func accountTypeSelected(dict: NSDictionary) {
        let authUrl = ((dict.value(forKey: "_links") as! [NSDictionary])[0]).value(forKey: "href") as! String
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
        vc.instituteName = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "name") as AnyObject).1
        vc.authUrl = authUrl
        vc.cantFetchAccountsDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        self.searchStr = newString
        
        var country_code = ""
        for item in self.countriesArray {
            let dict = (item as! NSDictionary)
            if dict.value(forKey: "isSelected") as! String == "1" {
                country_code = dict.value(forKey: "value") as! String
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.callApi(CountryCode: country_code)
        }
//        self.callApi(CountryCode: country_code)
        return true
    }
}
