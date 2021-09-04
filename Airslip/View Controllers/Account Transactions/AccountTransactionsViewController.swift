//
//  AirslipsViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 11/02/21.
//

import UIKit
import SDWebImage
import MaterialProgressBar
import SwiftSVG
import Alamofire
import SwiftyGif
import SwiftyJSON

class AccountTransactionsViewController: UIViewController , UIGestureRecognizerDelegate{

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var chooseAccountButton: UIButton!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var recentButton: UIButton!
    @IBOutlet weak var retailersButton: UIButton!
    @IBOutlet weak var recentBottomView: UIView!
    @IBOutlet weak var retailersBottomView: UIView!
    @IBOutlet weak var moreAccountsButton: UIButton!
    
    
    @IBOutlet weak var tableV: UITableView!
    var accountId = ""
    var transactionsArray = [NSDictionary]()
    var newTransactionsArray = [NSDictionary]()
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var AccountsView: UIView!
    
    @IBOutlet weak var chooseAccountView: UIView!
    @IBOutlet weak var accountsTableView: UITableView!
    
    @IBOutlet weak var expandIcon: UIImageView!
    var accountsArray = [NSDictionary]()
    
    @IBOutlet weak var searchTextField: UITextField!
  
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    @IBOutlet weak var noResultsFound: UIView!
    
    @IBOutlet weak var accountsTransactionsLoader: UIImageView!
    @IBOutlet weak var accountTransactionsHeaderView: UIView!
    @IBOutlet weak var accountTransactionsHeaderViewHeightConstraint: NSLayoutConstraint!
    
    
    var showLoader = true
    var refreshControl = UIRefreshControl()
    var offset = 0
    var totalCount = ""
    var searchStr = ""
    var currencySymbol = ""
    var isForTotalTransactions = false
    var viewAllTransactions = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.progressBar.tintColor = MAIN_COLOR
        
        self.tableV.estimatedRowHeight = 100
        self.searchTextField.delegate = self
       
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableV.addSubview(refreshControl)
        
        self.recentBottomView.backgroundColor = UIColor.black
        self.retailersBottomView.backgroundColor = hexStringToUIColor(hex: "#7C95B5")
        
        self.chooseAccountView.isHidden = true
        self.accountsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 5))
        self.accountsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 5))
        
       
        _ = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        _ = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        topView.addGestureRecognizer(tap2)
        AccountsView.addGestureRecognizer(tap3)
        
        print(self.accountsArray)
        if self.accountsArray.count > 0 {
            let bankDict = NSDictionary(dictionaryLiteral: ("icon","global-network"))
            self.accountsArray.insert(NSDictionary(dictionaryLiteral:  ("accountNickname","View All Accounts"),("id",""),("bank",bankDict)), at: 0)
            for (index,item) in accountsArray.enumerated() {
                let dict = item.mutableCopy() as! NSMutableDictionary
                if accountId == item.value(forKey: "id") as! String {
                    dict.setValue("1", forKey: "isSelected")
                }
                else {
                    dict.setValue("0", forKey: "isSelected")
                }
                self.accountsArray[index] = dict
            }
        }
                
        let spinner = UIActivityIndicatorView(style: .medium)
           spinner.startAnimating()
           spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableV.bounds.width, height: CGFloat(44))

        do {
            try self.accountsTransactionsLoader.setGifImage(UIImage(gifName: "loader.gif"))
        } catch {
            print(error)
        }
        
        self.offset = 0
        self.isForTotalTransactions = true
        self.callApi(limit: 10, offset: offset,loader: false)
    }
    
    override func viewDidLayoutSubviews() {
      SHADOW_EFFECT.makeBottomShadow(forView: self.chooseAccountView,top_shadow: true,cornerRadius: 10)
        self.AccountsView.layer.cornerRadius = 5.0
        self.AccountsView.layer.masksToBounds = false
        self.AccountsView.layer.backgroundColor = hexStringToUIColor(hex: "#F1F1F1").cgColor
        self.AccountsView.layer.shadowColor = UIColor.darkGray.cgColor
        self.AccountsView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        self.AccountsView.layer.shadowRadius = 5.0
        self.AccountsView.layer.shadowOpacity = 0.2
        self.AccountsView.layer.masksToBounds = false
        
    }
 
    @IBAction func moreAccountsButton(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreAccountsViewController") as! MoreAccountsViewController
        vc.accountsArray = self.accountsArray
        vc.selectedBankDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
 
    @objc func refresh(_ sender: AnyObject) {
        self.searchTextField.text = ""
        self.searchStr = ""
        self.showLoader = true
        
        self.offset = 0
        DispatchQueue.main.async {
            self.isForTotalTransactions = true
            self.callApi(limit: 10, offset: self.offset, loader: false)
        }
       
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.chooseAccountView.isHidden = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func recentButton(_ sender: UIButton) {
        self.recentBottomView.backgroundColor =  UIColor.black
        self.retailersBottomView.backgroundColor = hexStringToUIColor(hex: "#7C95B5")
        self.callApi(limit: 10, offset: offset, loader: false)
    }
    
    @IBAction func retailersButton(_ sender: UIButton) {
        self.recentBottomView.backgroundColor = hexStringToUIColor(hex: "#7C95B5")
        self.retailersBottomView.backgroundColor = UIColor.black
    }
    
    @IBAction func chooseAccountButton(_ sender: UIButton) {
        if self.chooseAccountView.isHidden {
            self.accountsTableView.reloadData()
            self.chooseAccountView.isHidden = false
            self.expandIcon.image = #imageLiteral(resourceName: "collapse")
        }
        else {
            self.chooseAccountView.isHidden = true
            self.expandIcon.image = #imageLiteral(resourceName: "expand")
        }
    }
    
    func callNewTransactionsApi() {
        self.showLoader = true
       var api_name = ""
        if self.viewAllTransactions {
          api_name = "/v1/transactions/new"
        }
        else {
           api_name = APINAME.init().accounts + "/\(accountId)" + "/transactions/new"
        }
        
        WebService.requestGetUrl(strURL: api_name, params: [:], is_loader_required: false) { (response) in
            print(response)
            self.showLoader = false
            self.newTransactionsArray.removeAll()
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
            }

            if let transactionsArray = response["transactions"] {
                self.newTransactionsArray = transactionsArray as! [NSDictionary]
                if self.transactionsArray.count > 0 {
                self.transactionsArray[0] = ["transactions":self.newTransactionsArray]
                }

                self.tableV.reloadData()
                self.accountsTableView.reloadData()
            }

        } failure: { (error) in
            self.showLoader = false
            print(error)
        }
    }
    
    //Mark :- Call Transactions Api
    func callApi(limit:Int,offset:Int,loader:Bool)  {
        WebService.authenticationFunction()
        for item in accountsArray {
           let dataDic = item
            if accountId == dataDic.value(forKey: "id") as! String {
                self.accountNameLabel.text = (dataDic.value(forKey: "accountNickname") as! String)
            }
        }
        
        var api_name = ""
        if self.viewAllTransactions {
            if searchStr != "" {
                api_name = APINAME.init().all_transactions + "?merchantName=\(searchStr)"
            }
            else {
             api_name = APINAME.init().all_transactions
            }
        }
        else {
        if searchStr != "" {
            api_name = APINAME.init().accounts + "/\(accountId)" + "/transactions" + "?limit=\(limit)&merchantName=\(searchStr)"
        }
        else {
         api_name = APINAME.init().accounts + "/\(accountId)" + "/transactions" + "?limit=\(limit)&offset=\(offset)"
        }
        }
        print(api_name)
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        
        var request = URLRequest(url: NSURL(string: (BASE_URL + api_name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
        print(BASE_URL + api_name)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
  
        AF.request(request)
            .responseString { response in
                self.tableV.tableHeaderView = UIView.init()
                // do whatever you want here
                if response.response?.statusCode == 424 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReAuthoriseViewController") as! ReAuthoriseViewController
                     vc.titleText = "Failed dependecy. Unable to complete request."
                     vc.authUrl = ""
                     vc.isFromAccountsTransactionPage = true
                     vc.retryCallProtocol = self
                     self.present(vc, animated: true, completion: nil)
                }
                
                switch response.result {
                case .success(_):
                    if let data = response.data
                    {
                        print(JSON(data))
                        if let dataDictionary = JSON(data).dictionaryObject
                        {
                            print(dataDictionary)
                            if self.isForTotalTransactions {
                                self.transactionsArray.removeAll()
                                let arr = [NSDictionary]()
                                let dict = [
                                    "transactions" : arr
                                ] as [String : Any]
                                self.transactionsArray.append(dict as NSDictionary)
                            }

                            self.progressBar.stopAnimating()
                            print(response)
                            if let error = dataDictionary["errorCode"] {
                                var reauthoriseLink = ""
                                if let linksArray = dataDictionary["_links"] {
                                    for item in (linksArray as! [NSDictionary]) {
                                        if item.value(forKey: "rel") as! String == "next" {
                                            reauthoriseLink = item.value(forKey: "href") as! String
                                        }
                                    }
                                }
                                print(error)
                               let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReAuthoriseViewController") as! ReAuthoriseViewController
                                vc.titleText = dataDictionary["message"] as! String
                                vc.authUrl = reauthoriseLink
                                vc.isFromAccountsTransactionPage = true
                                self.present(vc, animated: true, completion: nil)
                            }

                            if let errorMessage = dataDictionary["errorMessage"] {
                                COMMON_FUNCTIONS.showAlert(msg: errorMessage as! String, title: "")
                            }

                            if let pagedData = dataDictionary["pagedData"] {
                                self.totalCount = COMMON_FUNCTIONS.checkForNull(string: (pagedData as! NSDictionary)["pageCount"] as AnyObject).1
                                self.transactionsArray += (pagedData as! NSDictionary)["results"] as! [NSDictionary]
                              print(self.transactionsArray.count)
                                if self.transactionsArray.count > 0 {
                                    self.noResultsFound.isHidden = true
                                }
                                else {
                                    self.noResultsFound.isHidden = false
                                    self.searchTextField.endEditing(true)
                                }

                                if offset == 0 {
                                    self.callNewTransactionsApi()
                                }
                                self.offset += 1
                                DispatchQueue.main.async {
                                    self.tableV.tableFooterView?.isHidden = true
                                    self.tableV.reloadData()
                                    self.chooseAccountView.isHidden = true
                                }
                            }

                            if let currencySymbol = dataDictionary["currencySymbol"] {
                                self.currencySymbol = COMMON_FUNCTIONS.checkForNull(string: currencySymbol as AnyObject).1
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    self.tableV.tableHeaderView = UIView.init()
                    print(response.error.debugDescription)
                    break
                }
        }
        refreshControl.endRefreshing()
    }
}

extension AccountTransactionsViewController : UITableViewDelegate , UITableViewDataSource, RetryCallProtocol {
    func retryCall() {
        self.offset = 0
        self.isForTotalTransactions = true
        self.callApi(limit: 10, offset: offset,loader: false)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == accountsTableView {
            return 1
        }
        else if tableView == self.tableV {
            return transactionsArray.count
        }
        else {
          return newTransactionsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == accountsTableView {
            return self.accountsArray.count
        }
        else if tableView == self.tableV {
            if section == 0 {
                return 1
            }
            return (transactionsArray[section]["transactions"] as! NSArray).count
        }
        
        else {
            return (newTransactionsArray[section]["transactions"] as! NSArray).count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == accountsTableView {
            return 30
        }
        else if tableView == self.tableV {
            if indexPath.section == 0 {
                if self.newTransactionsArray.count > 0 {
                    return  (((self.newTransactionsArray[indexPath.row]).value(forKey: "transactions") as! NSArray).count > 0) ? CGFloat(70 * ((self.newTransactionsArray[indexPath.row]).value(forKey: "transactions") as! NSArray).count) + 120.0 : 0.0
                }
                else {
                    return 120.0
                }
            }
            return 80
        }
        else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableV {
       let lastSectionIndex = tableView.numberOfSections - 1
       let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
       if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {

           self.tableV.tableFooterView?.isHidden = false
        if self.transactionsArray.count > 0 {
        if offset < Int(totalCount)! {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.isForTotalTransactions = false
                self.callApi(limit: 10, offset: self.offset * 10,loader: false)
            }
        
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.tableV.tableFooterView?.isHidden = true
            }
          }
        }
       }
        }
   }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: (tableView == self.tableV) ? tableV.frame.size.width : tableView.frame.size.width, height: 50))
        headerView.backgroundColor = UIColor.white
        let groupedDate = UILabel(frame: CGRect(x:  (tableView == self.tableV) ? headerView.frame.origin.x + 25 : headerView.frame.origin.x + 15, y: headerView.frame.origin.y + 10, width: 120, height: 40))
        let dailyTotal = UILabel(frame: CGRect(x: headerView.frame.size.width - 150, y: headerView.frame.origin.y + 10, width: 120, height: 40))
        groupedDate.font = UIFont(name: REGULAR_FONT, size: 14.0)
        dailyTotal.font = UIFont(name: REGULAR_FONT, size: 14.0)
        dailyTotal.textAlignment = .right
        
        var dict = NSDictionary.init()
        if tableView == self.tableV {
            dict = self.transactionsArray[section]
        }
        else {
            dict = self.newTransactionsArray[section]
        }
        
        groupedDate.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "groupedDate") as AnyObject).1
        dailyTotal.text = self.currencySymbol + COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "dailyTotal") as AnyObject).1
        
        headerView.addSubview(groupedDate)
        headerView.addSubview(dailyTotal)
        if tableView != accountsTableView {
        return headerView
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: self.tableV.frame.size.width, height: 10))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == accountsTableView {
        return 0
        }
        else if tableView == self.tableV {
            return section == 0 ? 0 : 50
        }
        else {
            return self.newTransactionsArray.count > 0 ? 50 : 0
        }
    }
    
    func addLoaderView() {
        // You only need to adjust this frame to move it anywhere you want
        var boxView = UIView()
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10

        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()

        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Getting new transactions"

        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)

        view.addSubview(boxView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == accountsTableView {
            let cell: UITableViewCell = accountsTableView.dequeueReusableCell(withIdentifier: "cell")!
            let dict = self.accountsArray[indexPath.row]
            cell.textLabel?.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "accountNickname") as AnyObject).1
            
            if dict.value(forKey: "isSelected") as! String == "1" {
                cell.textLabel?.font = UIFont(name: SEMIBOLD, size: 13)
            }
            else {
                cell.textLabel?.font = UIFont(name: REGULAR_FONT, size: 13)
            }
 
            cell.selectionStyle = .none
            return cell
        }
        
        else if tableView == self.tableV {
            if indexPath.section == 0 {
                let nib = UINib(nibName: "NewTransactionsTableViewCell", bundle: nil)
                self.tableV.register(nib, forCellReuseIdentifier: "NewTransactionsTableViewCell")
                let cell = tableV.dequeueReusableCell(withIdentifier: "NewTransactionsTableViewCell") as! NewTransactionsTableViewCell
                cell.tableV.delegate = self
                cell.tableV.dataSource = self
   
                print(self.newTransactionsArray.count)
                if self.showLoader {
                    cell.gettingTransactionsLoaderView.isHidden = false
                    do {
                        try cell.loader.setGifImage(UIImage(gifName: "loader.gif"))
                    } catch {
                        print(error)
                    }
                }
                
                else {
                if self.newTransactionsArray.count > 0 {
                    cell.gettingTransactionsLoaderView.isHidden = true
                    cell.noTransactionsLblHeightConstraint.constant = 0
                    cell.headerViewHeightConstraint.constant = cell.newTransactionsLbl.heightForLabel() + 20
                }
                else {

                    cell.gettingTransactionsLoaderView.isHidden = true
                    cell.noTransactionsLblHeightConstraint.constant = cell.noTransactionsLbl.heightForLabel() + 20
                 }
                }
                cell.tableV.reloadData()
                
                cell.headerView.layer.cornerRadius = 10.0
                cell.tableV.layer.cornerRadius = 10.0
                cell.mainView.layer.cornerRadius = 10.0
                cell.mainView.layer.borderWidth = 1.0
                cell.mainView.layer.borderColor = UIColor.clear.cgColor
                cell.mainView.layer.masksToBounds = false

                cell.mainView.layer.backgroundColor = UIColor.white.cgColor
                cell.mainView.layer.shadowColor = UIColor.darkGray.cgColor
                cell.mainView.layer.shadowOffset = .zero
                cell.mainView.layer.shadowRadius = 5.0
                cell.mainView.layer.shadowOpacity = 0.2
                cell.mainView.layer.masksToBounds = false
                cell.tableV.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.tableV.layer.cornerRadius).cgPath
                
                cell.tableV.layer.shadowColor = UIColor.lightGray.cgColor
                cell.tableV.layer.shadowOffset = .zero
                cell.tableV.layer.shadowOpacity = 0.2
                cell.tableV.layer.shadowRadius = 10.0
                cell.tableV.clipsToBounds = true
                
                cell.selectionStyle = .none
                return cell
            }
            else {
        let nib = UINib(nibName: "AccountsTransactionsTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "AccountsTransactionsTableViewCell")
        let cell = tableV.dequeueReusableCell(withIdentifier: "AccountsTransactionsTableViewCell") as! AccountsTransactionsTableViewCell
        var dict = NSDictionary.init()
            dict = (self.transactionsArray[indexPath.section]["transactions"] as! [NSDictionary])[indexPath.row]
            print(dict)
            let authorisedTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "authorisedTime") as AnyObject).1
            let capturedTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "capturedTime") as AnyObject).1
            let merchantDict = dict.value(forKey: "merchant") as! NSDictionary
            if let icon = merchantDict.value(forKey: "icon") {
                cell.merchantLogo.image = UIImage(named: COMMON_FUNCTIONS.checkForNull(string: icon as AnyObject).1)
            }
            else {
                cell.merchantLogo.image = #imageLiteral(resourceName: "placeholder")
            }
            
             
        cell.merchantName.text = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "name") as AnyObject).1
                let merchantNameWidth = (COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "name") as AnyObject).1).width(withConstrainedHeight: cell.merchantName.frame.height, font: UIFont(name: REGULAR_FONT, size: 14)!)
                cell.merchantNameWidthConstraint.constant = merchantNameWidth > cell.mainView.frame.width/2 + 30 ? cell.mainView.frame.width/2 + 30 : merchantNameWidth

            if (authorisedTime != "" ? authorisedTime : capturedTime) == "" {
                cell.merchantNameCenterYConstraint.constant = 0.0
                cell.timeLbl.text = authorisedTime != "" ? authorisedTime : capturedTime
            }
            else {
                cell.merchantNameCenterYConstraint.constant = -12.5
                cell.timeLbl.text = authorisedTime != "" ? authorisedTime : capturedTime
            }

        let currencySymbol = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "currencySymbol") as AnyObject).1
            
        cell.amountLbl.text = currencySymbol + COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "amount") as AnyObject).1
                
                let merchantTransactionId = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "merchantTransactionId") as AnyObject).1
                if let bankIcon = dict.value(forKey: "bankIcon") {
                    cell.bankIcon.isHidden = false
                    cell.bankIcon.image = UIImage(named: bankIcon as! String)
                    cell.receiptIcon.isHidden = merchantTransactionId != "" ? false : true
                }
                else {
                    cell.bankIcon.image = UIImage(named: "receipt")
                    cell.bankIcon.isHidden = merchantTransactionId != "" ? false : true
                    cell.receiptIcon.isHidden = true
                }
     
                
        cell.selectionStyle = .none
        return cell
            }
        }
        
        else {
      
        let nib = UINib(nibName: "AccountsTransactionsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AccountsTransactionsTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTransactionsTableViewCell") as! AccountsTransactionsTableViewCell
        var dict = NSDictionary.init()
            dict = (self.newTransactionsArray[indexPath.section]["transactions"] as! [NSDictionary])[indexPath.row]
            print(dict)
            let authorisedTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "authorisedTime") as AnyObject).1
            let capturedTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "capturedTime") as AnyObject).1
            let merchantDict = dict.value(forKey: "merchant") as! NSDictionary
            if let icon = merchantDict.value(forKey: "icon") {
                cell.merchantLogo.image = UIImage(named: COMMON_FUNCTIONS.checkForNull(string: icon as AnyObject).1)
            }
            else {
                cell.merchantLogo.image = #imageLiteral(resourceName: "placeholder")
            }
 
            cell.merchantName.text = COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "name") as AnyObject).1
            let merchantNameWidth = (COMMON_FUNCTIONS.checkForNull(string: merchantDict.value(forKey: "name") as AnyObject).1).width(withConstrainedHeight: cell.merchantName.frame.height, font: UIFont(name: REGULAR_FONT, size: 14)!)

            cell.merchantNameWidthConstraint.constant = merchantNameWidth > cell.mainView.frame.width/2 + 30 ? cell.mainView.frame.width/2 + 30 : merchantNameWidth
            
            if (authorisedTime != "" ? authorisedTime : capturedTime) == "" {
                cell.merchantNameCenterYConstraint.constant = 0.0
                cell.timeLbl.text = authorisedTime != "" ? authorisedTime : capturedTime
            }
            else {
                cell.merchantNameCenterYConstraint.constant = -12.5
                cell.timeLbl.text = authorisedTime != "" ? authorisedTime : capturedTime
            }

        let currencySymbol = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "currencySymbol") as AnyObject).1
            
        cell.amountLbl.text = currencySymbol + COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "amount") as AnyObject).1
        
            cell.mainViewLeadingConstraint.constant = 10
            cell.mainViewTrailingConstraint.constant = 20
            
            let merchantTransactionId = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "merchantTransactionId") as AnyObject).1
            if let bankIcon = dict.value(forKey: "bankIcon") {
                cell.bankIcon.isHidden = false
                cell.bankIcon.image = UIImage(named: bankIcon as! String)
                cell.receiptIcon.isHidden = merchantTransactionId != "" ? false : true
            }
            else {
                cell.bankIcon.image = UIImage(named: "receipt")
                cell.bankIcon.isHidden = merchantTransactionId != "" ? false : true
                cell.receiptIcon.isHidden = true
            }
            
        cell.selectionStyle = .none
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == accountsTableView {
            let dict = self.accountsArray[indexPath.row]
            for (index,item) in self.accountsArray.enumerated() {
                let dataDic = (item ).mutableCopy() as! NSMutableDictionary
                if dataDic == dict {
                    dataDic.setValue("1", forKey: "isSelected")
                }
                else {
                    dataDic.setValue("0", forKey: "isSelected")
                }
                self.accountsArray[index] = dataDic
            }
            
            if self.accountsArray[indexPath.row].value(forKey: "accountNickname") as! String == "View All Accounts" {
                self.viewAllTransactions = true
            }
            else {
                self.viewAllTransactions = false
            }
            print(dict)
            self.accountId = dict.value(forKey: "id") as! String
            print(self.accountsArray)
            offset = 0
            self.transactionsArray.removeAll()
            self.callApi(limit: 10, offset: offset, loader: false)
        }
        else {
            if indexPath.section == 0 {
                return
            }
            
            var dict = NSDictionary.init()
            if tableView == self.tableV {
                dict = (self.transactionsArray[indexPath.section]["transactions"] as! [NSDictionary])[indexPath.row]
            }
            else {
                dict = (self.newTransactionsArray[indexPath.section]["transactions"] as! [NSDictionary])[indexPath.row]
            }
            print(dict)
            let authorisedDate = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "authorisedDate") as AnyObject).1
            let authorisedTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "authorisedTime") as AnyObject).1
            
            let capturedDate = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "capturedDate") as AnyObject).1
            let capturedTime = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "capturedTime") as AnyObject).1
            let accountID = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "accountId") as AnyObject).1
            let retailerTransactionId = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "merchantTransactionId") as AnyObject).1
            if retailerTransactionId != "" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptDetailViewController") as! ReceiptDetailViewController
                vc.accountId = self.viewAllTransactions ? accountID : self.accountId
                vc.retailerTransactionId = retailerTransactionId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NonAirslipPartnerViewController") as! NonAirslipPartnerViewController
                print(dict)
                let merchantDict = dict.value(forKey: "merchant") as! NSDictionary
                vc.merchantDict = merchantDict
                vc.amountStr = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "currencySymbol") as AnyObject).1 + COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "amount") as AnyObject).1
                vc.dateStr = authorisedDate != "" ? authorisedDate : capturedDate
                vc.timeStr = authorisedTime != "" ? authorisedTime : capturedTime
                vc.accountId = self.viewAllTransactions ? accountID : self.accountId
                vc.retailerTransactionId = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "bankTransactionId") as AnyObject).1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension AccountTransactionsViewController : UITextFieldDelegate, SwiftyGifDelegate, SelectedBankDelegate {
    func selectedBank(index: Int) {
        let dict = self.accountsArray[index]
        for (index,item) in self.accountsArray.enumerated() {
            let dataDic = (item ).mutableCopy() as! NSMutableDictionary
            if dataDic == dict {
                dataDic.setValue("1", forKey: "isSelected")
            }
            else {
                dataDic.setValue("0", forKey: "isSelected")
            }
            self.accountsArray[index] = dataDic
        }
        
        if self.accountsArray[index].value(forKey: "accountNickname") as! String == "View All Accounts" {
            self.viewAllTransactions = true
        }
        else {
            self.viewAllTransactions = false
        }
        print(dict)
        self.accountId = dict.value(forKey: "id") as! String
        print(self.accountsArray)
        offset = 0
        self.transactionsArray.removeAll()
        self.callApi(limit: 10, offset: offset, loader: false)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        self.searchStr = newString
        self.isForTotalTransactions = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.offset = 0
            self.callApi(limit: 10, offset: self.offset, loader: false)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {}
        else {
            self.offset = 0
            self.callApi(limit: 10, offset: self.offset, loader: false)
        }
    }
}

