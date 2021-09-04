//
//  MyAccountsViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 12/02/21.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Alamofire
import SwiftyJSON

class MyAccountsViewController: UIViewController, UIGestureRecognizerDelegate, UITabBarControllerDelegate {
    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topDescriptionLbl: UILabel!
    @IBOutlet weak var topDescriptionLblHeight: NSLayoutConstraint!
    @IBOutlet weak var tableV: UITableView!
  
    @IBOutlet weak var addAnotherBankButtonView: UIView!
    @IBOutlet weak var addAnotherBankLbl: UILabel!
    @IBOutlet weak var addAnotherBankButton: UIButton!
    @IBOutlet weak var viewAllAccountsButtonView: UIView!
    @IBOutlet weak var viewAllAccountsLbl: UILabel!
    @IBOutlet weak var viewAllAccountsButton: UIButton!
    
    @IBOutlet weak var footerV: UIView!
    @IBOutlet weak var footerVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerV: UIView!
    @IBOutlet weak var headerLoader: UIImageView!
    @IBOutlet weak var headerVHeightConsraint: NSLayoutConstraint!
    
    @IBOutlet weak var splashView: UIView!
    var accountsArray = [NSDictionary]()
    var personalAccounts = [NSDictionary]()
    var businessAccounts = [NSDictionary]()
    
    var refreshControl = UIRefreshControl()
    @IBAction func backButton(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashView.isHidden = true
        print(biometricOn)
        tabBarController?.tabBar.isHidden = biometricOn ? true : false
        self.tabBarController?.delegate = self
      
        if biometricOn {
        DispatchQueue.main.async {
            self.faceIDAuth()
         }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(faceIdAuthCalled(notification:)), name: Notification.Name("FaceIdAuthentication"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideSplashView(notification:)), name: Notification.Name("HideSplashView"), object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableV.addSubview(refreshControl)
        
        if !defaultHomePage {
//            self.tableV.tableFooterView = makeFooterView()
            self.footerV.isHidden = false
            self.footerVHeightConstraint.constant = 93
            self.pageTitleLbl.text = "New Accounts"
        }
        else {
//            self.tableV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 10))
//            self.tableV.tableFooterView = makeFooterView()
            self.footerV.isHidden = true
            self.footerVHeightConstraint.constant = 0
            self.pageTitleLbl.text = "My Accounts"
        }
      
//        self.backButton.isHidden = authenticatedUserNow ? false : true
        self.backButton.isHidden = true
        
        do {
            try self.headerLoader.setGifImage(UIImage(gifName: "loader.gif"))
        } catch {
            print(error)
        }

        self.tableV.tableHeaderView = self.makeHeaderView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 2000)) {
            
            if !defaultHomePage {
                do {
                    try self.fetchAccounts(Url: authorisationUrl)
                } catch let error {
                    print(error)
                }
            }
            else {
                do {
                    try self.callApi()
                } catch let error {
                    print(error)
                }
            }
        }
       
    }
    
    
    override func viewWillLayoutSubviews() {
        self.addAnotherBankButtonView.layer.cornerRadius = self.addAnotherBankButtonView.frame.height / 2
        self.addAnotherBankButtonView.layer.cornerRadius = self.addAnotherBankButtonView.frame.size.height/2
        self.addAnotherBankButtonView.layer.masksToBounds = false
        self.addAnotherBankButtonView.layer.backgroundColor = hexStringToUIColor(hex: "#2584B6").cgColor
        self.addAnotherBankButtonView.layer.shadowColor = UIColor.darkGray.cgColor
        self.addAnotherBankButtonView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        self.addAnotherBankButtonView.layer.shadowRadius = 5.0
        self.addAnotherBankButtonView.layer.shadowOpacity = 0.7
        self.addAnotherBankButtonView.layer.masksToBounds = false
        
        self.viewAllAccountsButtonView.layer.cornerRadius = self.viewAllAccountsButtonView.frame.height / 2
        self.viewAllAccountsButtonView.layer.masksToBounds = false
        self.viewAllAccountsButtonView.layer.backgroundColor = UIColor.white.cgColor
        self.viewAllAccountsButtonView.layer.shadowColor = UIColor.darkGray.cgColor
        self.viewAllAccountsButtonView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        self.viewAllAccountsButtonView.layer.shadowRadius = 5.0
        self.viewAllAccountsButtonView.layer.shadowOpacity = 0.7
        self.viewAllAccountsButtonView.layer.masksToBounds = false
        
    }
    
    func makeHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableV.frame.width, height: 50))
        var loader = UIImageView()
        do {
             loader = try UIImageView(gifImage: UIImage(gifName: "loader.gif"))
        } catch {
            print(error)
        }
        
        headerView.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
     
       let centerX =  NSLayoutConstraint(item: loader,attribute: .centerX,relatedBy: .equal,toItem: headerView,attribute: .centerX,multiplier: 1,constant: 0)
        let centerY =  NSLayoutConstraint(item: loader,attribute: .centerY,relatedBy: .equal,toItem: headerView,attribute: .centerY,multiplier: 1,constant: 0)
       let width = NSLayoutConstraint(item: loader, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        let height = NSLayoutConstraint(item: loader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        NSLayoutConstraint.activate([centerX,centerY,width,height])
        
        return headerView
    }
    
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
        if tabBarController.selectedIndex == 0 {
            defaultHomePage = true
            authenticatedUserNow = false
            
            if !defaultHomePage {
                self.footerV.isHidden = false
                self.footerVHeightConstraint.constant = 93
            }
            else {
//                self.tableV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 10))
    //            self.tableV.tableFooterView = makeFooterView()
                self.footerV.isHidden = true
                self.footerVHeightConstraint.constant = 0
            }
            
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 2000)) {
                            if !defaultHomePage {
                                do {
                                    try self.fetchAccounts(Url: authorisationUrl)
                                } catch let error {
                                    print(error)
                                }
                            }
                            else {
                                do {
                                    try self.callApi()
                                } catch let error {
                                    print(error)
                                }
                            }
                        }
                        self.viewDidLayoutSubviews()
                    }
        }
    }

    
    @IBAction func addAnotherBankButton(_ sender: UIButton) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
          homeVC.isFromManageVC = true
          self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func viewAllAccountsButton(_ sender: UIButton) {
                defaultHomePage = true
                authenticatedUserNow = false
                DispatchQueue.main.async {
                    self.footerV.isHidden = true
                    self.footerVHeightConstraint.constant = 0
                    self.pageTitleLbl.text = "My Accounts"
                    do {
                        try self.callApi()
                    } catch let error {
                        print(error)
                    }
                }
    }

    @objc func faceIdAuthCalled(notification:Notification)
        {
            self.faceIDAuth()
            return
        }

    @objc func hideSplashView(notification:Notification)
        {
        
        self.splashView.isHidden = true
        tabBarController?.tabBar.isHidden = false
            return
        }
    
    func makeFooterView() -> UIView {
       let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70))
        let footerButton = UIButton(frame: CGRect(x: footerView.frame.origin.x + 40, y: footerView.frame.origin.y + 10, width: footerView.frame.size.width - 80, height: 50))
        footerButton.layer.cornerRadius = 7
        footerButton.backgroundColor = UIColor.black
        footerButton.titleLabel?.font = UIFont(name: SEMIBOLD, size: 17)
        footerButton.setTitle("Add Another Bank", for: .normal)
        footerButton.setTitleColor(UIColor.white, for: .normal)
        footerButton.addTarget(self, action: #selector(viewAllAccounts(_sender:)), for: .touchUpInside)
        
        footerView.addSubview(footerButton)
        return footerView
    }
    
    @objc func viewAllAccounts(_sender:UIButton) {
//        defaultHomePage = true
//        authenticatedUserNow = false
//        DispatchQueue.main.async {
//            self.viewDidLoad()
//            self.viewDidLayoutSubviews()
//        }
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
          homeVC.isFromManageVC = true
          self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
//        self.tableV.tableHeaderView = self.makeHeaderView()
        if !defaultHomePage {
            do {
                try self.fetchAccounts(Url: authorisationUrl)
            } catch let error {
                print(error)
            }
        }
        else {
            do {
                try self.callApi()
            } catch let error {
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !defaultHomePage {
            self.topDescriptionLblHeight.constant = self.topDescriptionLbl.heightForLabel()
            self.topDescriptionLbl.isHidden = false
        }
        else {
            self.topDescriptionLblHeight.constant = 0
            self.topDescriptionLbl.isHidden = true
        }
    }
    
    // Mark :- Call Accounts Api
    
    func callApi() throws {
        WebService.requestGetUrl(strURL: APINAME.init().accounts, params: [:], is_loader_required: false) { (response) in
            print(response)
            self.tableV.tableHeaderView = UIView.init()
            self.accountsArray.removeAll()
            self.personalAccounts.removeAll()
            self.businessAccounts.removeAll()
            
            if let error = (response["errors"]) {
                COMMON_FUNCTIONS.showAlert(msg: ((error as! [NSDictionary])[0]).value(forKey: "message") as! String, title: "")
                return
            }
            
            if let res = response["accounts"] {
                self.accountsArray = res as! [NSDictionary]
            }
            if self.accountsArray.count > 0 {
                
                for item in self.accountsArray {
                    if item.value(forKey: "usageType") as! String == "PERSONAL" {
                        self.personalAccounts.append(item)
                    }
                    if item.value(forKey: "usageType") as! String == "BUSINESS" {
                        self.businessAccounts.append(item)
                    }
                }
            }
 
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        } failure: { (error) in
            self.tableV.tableHeaderView = UIView.init()
            print(error)
        }
        refreshControl.endRefreshing()
    }
    
    
    // Mark:- Fetch Accounts using Auth URL
    
    func fetchAccounts(Url: String) throws {
//        SVProgressHUD.show()
//        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
//        SVProgressHUD.setRingNoTextRadius(14.0)

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        
        var request = URLRequest(url: NSURL(string: Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
        print(Url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        WebService.authenticationFunction()
        
        AF.request(request)
            .responseString { response in
                self.tableV.tableHeaderView = UIView.init()
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
                            
                            if let res = dataDictionary["accounts"] {
                                self.accountsArray = res as! [NSDictionary]
                            }
                            
                            if self.accountsArray.count > 0 {
                                
                                for item in self.accountsArray {
                                    if item.value(forKey: "usageType") as! String == "PERSONAL" {
                                        self.personalAccounts.append(item)
                                    }
                                    if item.value(forKey: "usageType") as! String == "BUSINESS" {
                                        self.businessAccounts.append(item)
                                    }
                                }
                            }
                  
                       print(dataDictionary)
                            DispatchQueue.main.async {
                                self.tableV.reloadData()
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    self.tableV.tableHeaderView = UIView.init()
                    SVProgressHUD.dismiss()
                    print(response.error.debugDescription)
                    break
                }
        }
        refreshControl.endRefreshing()
    }

}

extension MyAccountsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if defaultHomePage {
            var sectionCount = 0
            if personalAccounts.count > 0 {
                sectionCount += 1
            }
            if businessAccounts.count > 0  {
                sectionCount += 1
            }
           return sectionCount
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaultHomePage {
            if section == 0 && self.personalAccounts.count > 0{
              return self.personalAccounts.count
             }
            return self.businessAccounts.count
          }
        return self.accountsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableV.frame.size.width, height: 80))
        headerView.backgroundColor = UIColor.white
        let accountTitleLbl = UILabel(frame: CGRect(x: headerView.frame.origin.x + 20, y: headerView.frame.origin.y + 10, width: headerView.frame.size.width, height: 25))
        let accountsCountLbl = UILabel(frame: CGRect(x: headerView.frame.origin.x + 20, y: headerView.frame.origin.y + 38, width: headerView.frame.size.width, height: 25))
        accountTitleLbl.font = UIFont(name: SEMIBOLD, size: 18)
        accountsCountLbl.font = UIFont(name: REGULAR_FONT, size: 16)
        if defaultHomePage {
            if section == 0 && self.personalAccounts.count > 0 {
                accountsCountLbl.text = "\(personalAccounts.count) Accounts"
                accountTitleLbl.text = "Personal"
             }
            else {
                accountsCountLbl.text = "\(businessAccounts.count) Accounts"
                accountTitleLbl.text = "Business"
            }
        }
        headerView.addSubview(accountTitleLbl)
        headerView.addSubview(accountsCountLbl)
        
        return defaultHomePage ? headerView : UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return defaultHomePage ? 70 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "AccountsTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "AccountsTableViewCell")
        let cell = tableV.dequeueReusableCell(withIdentifier: "AccountsTableViewCell") as! AccountsTableViewCell
        var dict = NSDictionary.init()
        if defaultHomePage {
            if indexPath.section == 0 && self.personalAccounts.count > 0{
                dict = self.personalAccounts[indexPath.row]
             }
            else {
                dict = self.businessAccounts[indexPath.row]
            }
            if indexPath.section == 1 {
             dict = self.businessAccounts[indexPath.row]
            }
          }
        else {
            if self.accountsArray.count > 0 {
               dict = self.accountsArray[indexPath.row]
            }
        }
        let bankDict = dict.value(forKey: "bank") as! NSDictionary
        let lastCardDigits = COMMON_FUNCTIONS.checkForNull(string: (dict.value(forKey: "lastCardDigits") as AnyObject)).1
        let sortCode = COMMON_FUNCTIONS.checkForNull(string: (dict.value(forKey: "sortCode") as AnyObject)).1
        let accountNumber = COMMON_FUNCTIONS.checkForNull(string: (dict.value(forKey: "accountNumber") as AnyObject)).1
        if let icon = bankDict.value(forKey: "icon") {
            cell.institutionIcon.image = UIImage(named: COMMON_FUNCTIONS.checkForNull(string: icon as AnyObject).1)
        }
        else {
            cell.institutionIcon.image = #imageLiteral(resourceName: "placeholder")
        }
        
        cell.accountNicknameLbl.text = COMMON_FUNCTIONS.checkForNull(string: (dict.value(forKey: "accountNickname") as AnyObject)).1
        if lastCardDigits == "" {
            cell.sortCodeLbl.text = sortCode
            cell.accountNumberLbl.text = accountNumber
            cell.accountNumberLbl.isHidden = false
        }
        else {
            cell.sortCodeLbl.text = lastCardDigits
            cell.accountNumberLbl.text = accountNumber
            cell.accountNumberLbl.isHidden = true
        }
        
        cell.currencyCodeLbl.text = COMMON_FUNCTIONS.checkForNull(string: (dict.value(forKey: "currencyCode") as AnyObject)).1
   
        cell.mainView.layer.cornerRadius = 5.0
        cell.mainView.layer.masksToBounds = false
        cell.mainView.layer.backgroundColor = UIColor.white.cgColor
        cell.mainView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mainView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        cell.mainView.layer.shadowRadius = 5.0
        cell.mainView.layer.shadowOpacity = 0.2
        cell.mainView.layer.masksToBounds = false
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary.init()
        if defaultHomePage {
            if indexPath.section == 0 && self.personalAccounts.count > 0 {
                dict = self.personalAccounts[indexPath.row]
             }
            else {
                dict = self.businessAccounts[indexPath.row]
            }
            if indexPath.section == 1 {
            dict = self.businessAccounts[indexPath.row]
            }
          }
        else {
        dict = self.accountsArray[indexPath.row]
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountTransactionsViewController") as! AccountTransactionsViewController
        vc.accountId = dict.value(forKey: "id") as! String
        vc.accountsArray = self.accountsArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
