//
//  ActionSheetViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 24/02/21.
//

import UIKit

protocol ManualAndTutorialsDelegate {
    func goToManualAndTutorials()
}

class ActionSheetViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var crossLbl: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var productItemLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableV: UITableView!
    
    var dataArray = NSMutableArray.init()
    
    var productItem = ""
    var itemDict = NSDictionary.init()
    var merchantDict = NSDictionary.init()
    var manualAndTutorialsDelegate : ManualAndTutorialsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        let dic1:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "share")),("title","Share"))
        let dic2:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "leave-review")),("title","Leave Review"))
        let dic3:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "manual")),("title","Manual & Tutorial"))
        let dic4:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "care-tips")),("title","Care Tips"))
 
        self.productItemLbl.text = self.productItem
        
        if itemDict.count > 0 {
            if COMMON_FUNCTIONS.checkForNull(string: itemDict.value(forKey: "productUrl") as AnyObject).1 == "" {
                dataArray = NSMutableArray(objects: dic2,dic3,dic4)
            }
            else {
            dataArray = NSMutableArray(objects: dic1,dic2,dic3,dic4)
            }
        }
//        dataArray = NSMutableArray(objects: dic1,dic2,dic3,dic4)
 
        print(itemDict)
        print(merchantDict)
        
        self.tableV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        self.tableV.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.crossLbl.layer.cornerRadius = self.crossLbl.frame.size.height/2
        self.crossLbl.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
        self.crossButton.layer.cornerRadius = self.crossButton.frame.size.height/2
        self.crossLbl.layer.masksToBounds = true
        self.crossButton.layer.masksToBounds = true
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ActionSheetViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "ManageTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "ManageTableViewCell")
        let cell = tableV.dequeueReusableCell(withIdentifier: "ManageTableViewCell") as! ManageTableViewCell
        cell.cellSwitch.isHidden = true
        
        let dic = dataArray[indexPath.row] as! NSDictionary
        let img = dic.object(forKey: "image") as! UIImage
        cell.imgView.image = img
        cell.titleLbl.text = (dic.object(forKey: "title") as! String)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = dataArray[indexPath.row] as! NSDictionary
        print(dic)
        let title = dic.value(forKey: "title") as! String
        if title == "Share" {
            _ = COMMON_FUNCTIONS.checkForNull(string: self.itemDict.value(forKey: "description") as AnyObject).1 + "\n\n"
            let image = COMMON_FUNCTIONS.checkForNull(string: itemDict.value(forKey: "imageUrl") as AnyObject).1
            let merchantName = COMMON_FUNCTIONS.checkForNull(string: self.merchantDict.value(forKey: "name") as AnyObject).1
            let productItem = COMMON_FUNCTIONS.checkForNull(string: self.merchantDict.value(forKey: "item") as AnyObject).1
            
            let productUrl = URL(string: COMMON_FUNCTIONS.checkForNull(string:  itemDict.value(forKey: "productUrl") as AnyObject).1)
            let detailStr = "\n" + "I just made a purchase from \(merchantName)!\n\(productItem)"
          
            var itemImg = UIImage.init()
            let data = try? Data(contentsOf: URL(string: image)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
             DispatchQueue.main.async {
                itemImg = UIImage(data: data!)!
             }
       
            let objectsToShare = [productUrl!,detailStr] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
        if title == "Manual & Tutorial" {

            self.dismiss(animated: false, completion: nil)
            manualAndTutorialsDelegate.goToManualAndTutorials()
        }
        
    }
}
