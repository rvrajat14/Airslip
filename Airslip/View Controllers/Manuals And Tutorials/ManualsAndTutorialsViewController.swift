//
//  ManualsAndTutorialsViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 11/03/21.
//

import UIKit
import SDWebImage

class ManualsAndTutorialsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var merchantImageView: UIImageView!
    @IBOutlet weak var merchantWebsiteUrl: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var tutorialsButton: UIButton!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var manualBottomView: UIView!
    @IBOutlet weak var tutorialBottomView: UIView!
    @IBOutlet weak var merchantWebsiteButton: UIButton!
    
    var merchantName = ""
    var merchantLogo = ""
    var companyUrl = ""
    var dataArray = NSMutableArray.init()
    override func viewDidLoad() {
        super.viewDidLoad()


        self.manualBottomView.backgroundColor = UIColor.black
        self.tutorialBottomView.backgroundColor = hexStringToUIColor(hex: "#7C95B5")

        self.tableV.estimatedRowHeight = 100
//        self.tableV.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        self.tableV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        self.merchantImageView.sd_setImage(with: URL(string: self.merchantLogo), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            var webUrl = companyUrl
            webUrl = webUrl.replacingOccurrences(of: "https://www.", with: "")
            webUrl = webUrl.replacingOccurrences(of: "https://", with: "")
           print(webUrl)
        let underlineAttributedString = NSAttributedString(string: webUrl, attributes: underlineAttribute)
        self.merchantWebsiteUrl.attributedText = underlineAttributedString
        self.merchantWebsiteUrl.textColor = UIColor.black

        self.callApi()
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func merchantWebsiteButton(_ sender: UIButton) {
        guard let url = URL(string: companyUrl) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
        else {
            COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + companyUrl, title: "")
        }
    }
 
    @IBAction func tutorialsButton(_ sender: UIButton) {
        self.tutorialBottomView.backgroundColor = UIColor.black
        self.manualBottomView.backgroundColor = hexStringToUIColor(hex: "#7C95B5")
        self.dataArray.removeAllObjects()
        self.tableV.reloadData()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
    }
 
    @IBAction func manualButton(_ sender: UIButton) {
        self.manualBottomView.backgroundColor =  UIColor.black
        self.tutorialBottomView.backgroundColor = hexStringToUIColor(hex: "#7C95B5")
        self.callApi()
    }
    
    func callApi() {
        self.merchantName = self.merchantName.replacingOccurrences(of: " ", with: "_")
        let api_name = APINAME.init().get_manuals + "?merchantName=\(self.merchantName)"
        print(api_name)
        WebService.requestGetUrl(strURL: api_name, params: NSDictionary.init(), is_loader_required: true) { (response) in
            print(response)
            if let userManuals = response["userManuals"] {
                for item in userManuals as! [NSDictionary] {
                    self.dataArray.add(item)
                }
            }
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        } failure: { (error) in
            print(error)
        }
    }
    
}

extension ManualsAndTutorialsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "ManualAndTutorialTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "ManualAndTutorialTableViewCell")
        let cell = tableV.dequeueReusableCell(withIdentifier: "ManualAndTutorialTableViewCell") as! ManualAndTutorialTableViewCell
        let dict = self.dataArray[indexPath.row] as! NSDictionary
        print(dict)
        let imageUrl = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "productImageUrl") as AnyObject).1
        let productItem = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "productItem") as AnyObject).1
        cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached, completed: nil)
        cell.titleLbl.text = productItem
        cell.titleLbl.isHidden = true
        cell.titleTextView.text = productItem
        
        cell.mainButton.tag = indexPath.row
        cell.mainButton.addTarget(self, action: #selector(mainButtonTapped(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dict = self.dataArray[indexPath.row] as! NSDictionary
//        print(dict)
//        var productLink = ""
//        if let links = dict.value(forKey: "_links") {
//            for item in links as! [NSDictionary] {
//                productLink = COMMON_FUNCTIONS.checkForNull(string: item.value(forKey: "href") as AnyObject).1
//            }
//        }
//        
//        guard let url = URL(string: productLink) else {
//             return
//         }
//        if UIApplication.shared.canOpenURL(url) {
//             UIApplication.shared.open(url, options: [:], completionHandler: nil)
//         }
//        else {
//            COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + companyUrl)
//        }
//        
//    }
    
    @objc func mainButtonTapped(_ sender : UIButton) {
        let dict = self.dataArray[sender.tag] as! NSDictionary
        print(dict)
        var productLink = ""
        if let links = dict.value(forKey: "_links") {
            for item in links as! [NSDictionary] {
                productLink = COMMON_FUNCTIONS.checkForNull(string: item.value(forKey: "href") as AnyObject).1
            }
        }
        
        guard let url = URL(string: productLink) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
        else {
            COMMON_FUNCTIONS.showAlert(msg: "Don't know how to open URI: " + companyUrl, title: "")
        }
        
    }
    

}
