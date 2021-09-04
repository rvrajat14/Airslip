//
//  MoreAccountsViewController.swift
//  Airslip
//
//  Created by Rajat Verma on 05/08/21.
//

import UIKit

protocol SelectedBankDelegate {
    func selectedBank(index:Int)
}
class MoreAccountsViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    var accountsArray = [NSDictionary]()
    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    var selectedBankDelegate : SelectedBankDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mainView.roundTop(radius: 20.0)
        backView.addGestureRecognizer(tap)
        print(self.accountsArray)
        self.mainViewHeightConstraint.constant = self.view.frame.height/2
        self.tableV.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableV.frame.size.width, height: 25))
        self.tableV.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableV.frame.size.width, height: 35))
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MoreAccountsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.accountsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "AccountsTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "AccountsTableViewCell")
        let cell = self.tableV.dequeueReusableCell(withIdentifier: "AccountsTableViewCell") as! AccountsTableViewCell
        var dict = NSDictionary.init()
        dict = self.accountsArray[indexPath.row]
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
        
        if cell.sortCodeLbl.text == "" && cell.accountNumberLbl.text == "" {
            cell.accountNocknameTopConstraint.constant = 12.5
        }
        else {
            cell.accountNocknameTopConstraint.constant = 0
        }
        
        cell.mainView.layer.cornerRadius = 5.0
        cell.mainView.layer.masksToBounds = false
        cell.mainView.layer.backgroundColor = (dict.value(forKey: "isSelected") as! String == "1") ? hexStringToUIColor(hex: "#D1EFF3").cgColor : UIColor.white.cgColor
        cell.mainView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mainView.layer.shadowOffset = CGSize(width: -1.0, height: 5.0)//CGSizeMake(0, 2.0);
        cell.mainView.layer.shadowRadius = 5.0
        cell.mainView.layer.shadowOpacity = 0.2
        cell.mainView.layer.masksToBounds = false
        
        cell.currencyCodeLbl.isHidden = true
   
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        self.selectedBankDelegate.selectedBank(index: indexPath.row)
    }
    
}
