//
//  ManageViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 11/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage

class ManageViewController: UIViewController {

    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var splashView: UIView!
    
    var window: UIWindow!
    var dataArray = NSMutableArray.init()
    var user_image = UIImage.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        self.splashView.isHidden = true
    }
    
    @objc func faceIdAuthCalled(notification:Notification)
        {
            self.faceIDAuth()
            return
        }
    
    override func viewWillAppear(_ animated: Bool) {

        self.getUserPhoto()
        
    }
    
    func setData() {
        
        let dic1:NSDictionary = NSDictionary(dictionaryLiteral: ("image",self.user_image),("title","My Profile"))
        let dic2:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "museum")),("title","Add Bank"))
        let dic3:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "face-id")),("title","Face ID"))
        let dic4:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "logout")),("title","Logout"))
       
        dataArray = NSMutableArray(objects: dic1,dic2,dic3,dic4)
        DispatchQueue.main.async {
            self.tableV.reloadData()
        }
    }
    
    //Mark :- Logout Api
    
    func callLogoutApi() {

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        
//        let strUrl = APINAME.init().get_user_photo
    let strUrl = IDENTITY_BASE_URL + "/v1/identity/logout"
    
    var request = URLRequest(url: NSURL(string: strUrl)! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
    WebService.authenticationFunction()
        
        AF.request(request)
            .response { (response) in
                print(response.response?.statusCode)
               let statusCode = response.response?.statusCode
                if (statusCode == 200) {
                    SVProgressHUD.dismiss()
                    
                    userDefaults.removeObject(forKey: "user_email")
                    userDefaults.removeObject(forKey: "access_token")
                    userDefaults.removeObject(forKey: "isNewUser")
                    userDefaults.removeObject(forKey: "biometryOn")

        var request = URLRequest(url: NSURL(string: strUrl)! as URL)
        print(strUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        WebService.authenticationFunction()
        
        AF.request(request)
            .responseString { response in
                // do whatever you want here
                print(response.response?.statusCode)
                if response.response?.statusCode == 200 {
                    print(userDefaults.value(forKey: "biometricOn") as! Bool)
                    userDefaults.removeObject(forKey: "user_email")
                    userDefaults.removeObject(forKey: "access_token")
                    userDefaults.removeObject(forKey: "isNewUser")
                    userDefaults.removeObject(forKey: "biometricOn")

               
                    let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? UINavigationController
                    if let window = self.window {
                        window.rootViewController = yourVc
                    }
                    self.window?.makeKeyAndVisible()
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
                    }
                    break
                    
                case .failure(_):
                    SVProgressHUD.dismiss()

                switch response.result {
                case .success(_):
                    break
                    
                case .failure(_):

                    print(response.error.debugDescription)
                    break
                }
        }

    }
                }
            }
    }
    
    //Mark :- Get User Photo Api
    
    func getUserPhoto() {
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
        WebService.authenticationFunction()
            
            AF.request(request)
                .response { (response) in
                    print(response.response?.statusCode)
                   let statusCode = response.response?.statusCode
                    if (statusCode == 404) || (strUrl.contains("logout") && statusCode == 200) || (statusCode == 204) {
                        self.user_image = UIImage.init()
//                        SVProgressHUD.dismiss()
                       return
                    }
                    
                    if statusCode == 200 {
        
                    if let data = response.data {
                        self.user_image = UIImage(data: data)!
                      }
                        self.tableV.reloadData()
                        
                    }
                    else {
                        self.user_image = UIImage.init()
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

}

extension ManageViewController : UITableViewDelegate , UITableViewDataSource {
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
        cell.imgView.contentMode = .scaleAspectFill
        let dic = dataArray[indexPath.row] as! NSDictionary
        let title = (dic.object(forKey: "title") as! String)
        cell.titleLbl.text = title
        if title == "My Profile" {
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.height / 2
            cell.imgView.layer.masksToBounds = true
            if  self.user_image != UIImage.init() {
                cell.imgView.image = self.user_image
            }
            else {
                cell.imgView.image = #imageLiteral(resourceName: "userPlaceholder")
            }
        }
        else {
            let img = dic.object(forKey: "image") as! UIImage
            cell.imgView.image = img
        }
        
        if title == "Face ID" {
//            cell.switchWidthConstraint.constant = 30
            cell.cellSwitch.isHidden = false
        }
        else {
//            cell.switchWidthConstraint.constant = 0
            cell.cellSwitch.isHidden = true
        }
        
        print(biometricOn)
        if biometricOn {
            cell.cellSwitch.isOn = true
        }
        else {
            cell.cellSwitch.isOn = false
        }
        
        cell.cellSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = dataArray[indexPath.row] as! NSDictionary
        if dic.value(forKey: "title") as! String == "Logout" {
            self.callLogoutApi()
            return
        }
        
        if dic.value(forKey: "title") as! String == "Add Bank" {
          let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeVC.isFromManageVC = true
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        
        if dic.value(forKey: "title") as! String == "My Profile" {
          let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(homeVC, animated: true)
        } 
        if dic.value(forKey: "title") as! String == "Face ID" {
            return
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        print(sender.isOn)
        biometricOn = sender.isOn ? true : false
        print(biometricOn)
        COMMON_FUNCTIONS.updateFaceId()
    }
    
}
