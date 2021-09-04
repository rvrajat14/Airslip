//
//  AccountTypeViewController.swift
//  Airslip
//
//  Created by Rajat Verma on 22/06/21.
//

import UIKit

protocol AccountTypeDelegate {
    func accountTypeSelected(dict:NSDictionary)
}

class AccountTypeViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableV: UITableView!
    var bankDict = NSDictionary.init()
    var accountTypeArray = [NSDictionary].init()
    var accountTypeDelegate : AccountTypeDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bankName = COMMON_FUNCTIONS.checkForNull(string: self.bankDict.value(forKey: "name") as AnyObject).1
        self.titleLbl.text = "\(bankName) has more than one account, what account would you like to use?"
        
        self.mainView.layer.cornerRadius = 7
        self.titleLblHeightConstraint.constant = self.titleLbl.heightForLabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        if bankDict.count > 0 {
            self.accountTypeArray = bankDict.value(forKey: "bankTypes") as! [NSDictionary]
            if self.accountTypeArray.count > 2 {
                self.tableV.isScrollEnabled = true
            }
            else {
                self.tableV.isScrollEnabled = false
            }
        }
        self.tableV.reloadData()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AccountTypeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "AccountTypeTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "AccountTypeTableViewCell")
        let cell = tableV.dequeueReusableCell(withIdentifier: "AccountTypeTableViewCell") as! AccountTypeTableViewCell
        let dict = self.accountTypeArray[indexPath.row]
        cell.titleLbl.text = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "name") as AnyObject).1
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.accountTypeArray[indexPath.row]
        self.dismiss(animated: false, completion: nil)
        accountTypeDelegate.accountTypeSelected(dict: dict)
    }
    
}
