//
//  MyProfileViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 24/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import GoogleMaps
import GooglePlaces
import Resolver

class MyProfileViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIGestureRecognizerDelegate{
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var headerLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userPlaceHolderImage: UIImageView!

    let datePicker = DatePickerDialog()
    
    var placemark: CLPlacemark!
    var placesClient: GMSPlacesClient!
    var googlePlacesArray = NSArray.init()
    var dataArray = NSMutableArray.init()
    var userImgUrl = ""
    var googleTableView = UITableView()
    
    var userDictionaryOld = NSDictionary.init()
    var houseNumberDict:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","House No."),("value",""))
    
    var reloadButtonTapped = false
    var postcodeSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2
        
        userImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        
        // Table Footer View
        self.tableV.tableFooterView = getFooterView()
        self.getUser()
    }

    
    func getFooterVieww() -> UIView {
        let footerV = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2 ))
        googleTableView = UITableView(frame: CGRect(x: footerV.frame.origin.x, y: footerV.frame.origin.y + 20, width: tableV.frame.size.width, height: footerV.frame.size.height - 40))
        googleTableView.delegate = self
        googleTableView.dataSource = self
 
        footerV.addSubview(googleTableView)
        return footerV
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        let footerButton = UIButton(frame: CGRect(x: footerView.frame.origin.x + 120, y: footerView.frame.origin.y + 20, width: footerView.frame.width - 240, height: 50))
        footerButton.addTarget(self, action: #selector(updateUserProfileButton(_:)), for: .touchUpInside)
        
        footerButton.setTitleColor(UIColor.white, for: .normal)
        footerButton.setTitle("Update", for: .normal)
        footerButton.titleLabel?.font = UIFont(name: SEMIBOLD, size: 17)
        footerButton.layer.cornerRadius = 7
        footerButton.layer.masksToBounds = true
        footerButton.backgroundColor = UIColor.black
        footerView.addSubview(footerButton)
        
        return footerView
    }
    
    @objc func updateUserProfileButton(_ sender : UIButton) {
        self.updateUserProfile()
    }
    
    func setData(response : NSDictionary) {
//        if self.userImgUrl == "" {
//            self.userPlaceHolderImage.isHidden = false
//            self.userImage.isHidden = false
//            self.userImage.backgroundColor = hexStringToUIColor(hex: "#DADADA")
//        }
//        else {
//            self.userPlaceHolderImage.isHidden = true
//            self.userImage.isHidden = false
//            self.userImage.sd_setImage(with: URL(string: self.userImgUrl), placeholderImage: #imageLiteral(resourceName: "camera"), options: .refreshCached, completed: nil)
//            self.userImage.backgroundColor = UIColor.white
//        }
        
        print(response)
    var email = "" , first_name = "" , surname = "" , gender = "" , dateOfBirth = "" , postalCode = "" , firstLineAddress = "" , secondLineAddress = "" , city = "" , county = "" , country = ""
        
        email = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "email") as AnyObject).1
        first_name = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "firstName") as AnyObject).1
        surname = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "surname") as AnyObject).1
        gender = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "gender") as AnyObject).1
        dateOfBirth = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "dateOfBirth") as AnyObject).1
        
        if dateOfBirth != "" {
        let formatter = ISO8601DateFormatter()
            formatter.formatOptions = .withFullDate
            let date = formatter.date(from: dateOfBirth)!
            dateOfBirth = formatter.string(from: date)
           print(dateOfBirth)
           dateOfBirth = dateOfBirth.toDateString(inputDateFormat: "yyyy-MM-dd", ouputDateFormat: "dd/MMM/yyyy")
        }
                
        postalCode = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "postalcode") as AnyObject).1
     
        let dic0:NSDictionary = NSDictionary(dictionaryLiteral: ("image",UIImage(named: "email-icon")!),("placeholder","Email"),("value",email))
        let dic1:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "name")),("placeholder","First Name"),("value",first_name))
        let dic2:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "name")),("placeholder","Surname"),("value",surname))
        let dic3:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "gender")),("placeholder","Gender"),("value",gender))
        let dic4:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "date-of-birth")),("placeholder","Date of Birth"),("value",dateOfBirth))
//        let dic5:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Postal Code"),("value",postalCode))
//        let dic6:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Start typing address..."),("value",NSDictionary.init()))
        
        let dic6:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Enter your postcode..."),("value",NSDictionary.init()))
        
//        dataArray = NSMutableArray(objects: dic1,dic2,dic3,dic4,dic6)
        
        let FirstLineAddress = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "firstLineAddress") as AnyObject).1
        
        
        if FirstLineAddress != "" {
            let FirstLineAddress = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "firstLineAddress") as AnyObject).1
            let secondLineAddress = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "secondLineAddress") as AnyObject).1
            let city = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "city") as AnyObject).1
            let county = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "county") as AnyObject).1
            let postalcode = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "postalcode") as AnyObject).1
            let country = COMMON_FUNCTIONS.checkForNull(string: response.value(forKey: "country") as AnyObject).1
            
            let dic7:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","First Line Address"),("value",FirstLineAddress))
            let dic8:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Second Line Address"),("value",secondLineAddress))
            let dic9:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","City"),("value",city))
            let dic10:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","County"),("value",county))
            let dic11:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Postcode"),("value",postalcode))
            let dic12:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Country"),("value",country))
            
            dataArray = NSMutableArray(objects: dic0,dic1,dic2,dic3,dic4,dic7,dic8,dic9,dic10,dic11,dic12)
  
        }
        else {
        dataArray = NSMutableArray(objects: dic0,dic1,dic2,dic3,dic4,dic6)
        }
        
        
        self.tableV.reloadData()
        if !reloadButtonTapped {
        self.getUserPhoto()
        }
    }
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Photo!", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: {
                imagePicker.delegate = self
            })
        }))
        alertController.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
            let imagePicker = UIImagePickerController.init()
           
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: {
            imagePicker.delegate = self
                
            })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel")
        }))
        let popPresenter = alertController.popoverPresentationController
        popPresenter?.sourceView = self.view
        popPresenter?.sourceRect = self.view.bounds
        self.present(alertController, animated: true, completion: nil)
//        showImagePickerController(sourceType: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var userImage = UIImage()
        if let pickedImage = info[.originalImage]  as? UIImage {
//            print(pickedImage)
            userImage = pickedImage
//            self.userImage.image = userImage
        }
         self.dismiss(animated: true, completion: nil)
        let image_data = userImage.jpegData(compressionQuality: 0.5) as AnyObject
        print(image_data)
        apiMultipart(imageData: image_data)
    }
    
    
    //MARK: - Upload Image
    
    func apiMultipart(imageData: AnyObject?) {
        WebService.authenticationFunction()
//        let serviceName = BASE_URL + APINAME.init().get_user_photo
        let serviceName = IDENTITY_BASE_URL + "/v1/profile/photo"
        
        SVProgressHUD.show()
        print(serviceName)
        let headers: HTTPHeaders
          headers = ["Content-type": "multipart/form-data",
                     "Content-Disposition" : "form-data",
                     "Authorization": "\(token_type) \(access_token)"]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData as! Data, withName: "photo" , fileName: "image.png", mimeType: "image/png")
        },to: serviceName, usingThreshold: UInt64.init(),method: .post,headers: headers)
        .response { (response) in
            SVProgressHUD.dismiss()
            print(response.result)
            self.getUserPhoto()
        }
    }
    
    //Mark :- Get User Photo Api
    
    func getUserPhoto() {
    
        WebService.authenticationFunction()
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)
 
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
            
//        let strUrl = APINAME.init().get_user_photo
        let strUrl = IDENTITY_BASE_URL + "/v1/profile/photo"
        
        var request = URLRequest(url: NSURL(string: strUrl)! as URL)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
     
//            print(BASE_URL.appending(strUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        print(strUrl)
            AF.request(request)
                .response { (response) in
                    print(response.response?.statusCode)
                   let statusCode = response.response?.statusCode
                    if (statusCode == 404) || (strUrl.contains("logout") && statusCode == 200) || (statusCode == 204) {
                        SVProgressHUD.dismiss()
                        self.userPlaceHolderImage.isHidden = false
                        self.userImage.image = UIImage.init()
                        self.userImage.backgroundColor = self.hexStringToUIColor(hex: "#DADADA")
                       return
                    }
                    if statusCode == 200 {
        
                  if let data = response.data {
                    self.userImage.image = UIImage(data: data)
                    self.userPlaceHolderImage.isHidden = true
                    self.userImage.isHidden = false
                    self.userImage.backgroundColor = UIColor.white
                      }
                        
                    }
                    else {
                        self.userPlaceHolderImage.isHidden = false
                        self.userImage.image = UIImage.init()
                        self.userImage.backgroundColor = self.hexStringToUIColor(hex: "#DADADA")
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
                            
//                            let res = JSON(data)
//                            if res == nil {
//                                NotificationCenter.default.post(name: NSNotification.Name.init("LogoutNotification"), object: nil)
//                            }
                            
                            if let dataDictionary = JSON(data).dictionaryObject
                            {
                                    print(dataDictionary)
                            }
                            if let dataArray = JSON(data).arrayObject
                            {
                               print(dataArray)
                            }
//                            self.getUser()
                        }
                        break
                        
                    case .failure(_):
                        SVProgressHUD.dismiss()
                        print(response.error.debugDescription)
//                        self.getUser()
                        break
                    }
            }
            
    }


 
    //Mark :- Get User Api
    
    func getUser() {
        WebService.authenticationFunction()
        SVProgressHUD .show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)
 
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
            
//        let strUrl = APINAME.init().user
        let strUrl = IDENTITY_BASE_URL + "/v1/profile"
        
        var request = URLRequest(url: NSURL(string: strUrl)! as URL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
        
            print(BASE_URL.appending(strUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            AF.request(request)
                .response { (response) in
                    print(response.response?.statusCode)
                   let statusCode = response.response?.statusCode
                    if (statusCode == 404) || (strUrl.contains("logout") && statusCode == 200) {
                       return
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
                                self.userDictionaryOld = dataDictionary as NSDictionary
                                self.setData(response: self.userDictionaryOld)
                                return
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        SVProgressHUD.dismiss()
                        print(response.error.debugDescription)
                        self.getUserPhoto()
                        break
                        
                    }
            }
            
        self.setData(response: NSDictionary.init())
    }
    
    //Mark Update User Profile
    
    func updateUserProfile() {
        var email = "" , first_name = "" , surname = "" , gender = "" , dateOfBirth = "" , postalCode = "" , firstLineAddress = "" , secondLineAddress = "" , city = "" , county = "" , country = ""
        
        self.googlePlacesArray = NSArray.init()
        for item in dataArray {
            let dic = item as! NSDictionary
            let placeHolder = dic.value(forKey: "placeholder") as! String
//            if placeHolder == "Start typing address..." {
//                if placeHolder == "Start typing address..." {
//                    let value = dic.value(forKey: "value") as! NSDictionary
//                    print(value)
//                    let locality = COMMON_FUNCTIONS.checkForNull(string: value.value(forKey: "locality") as AnyObject).1
//                    let sublocality = COMMON_FUNCTIONS.checkForNull(string: value.value(forKey: "sublocality") as AnyObject).1
//                    let cityStr = COMMON_FUNCTIONS.checkForNull(string:  value.value(forKey: "subAdministrativeArea") as AnyObject).1
//                    let countryStr = COMMON_FUNCTIONS.checkForNull(string:  value.value(forKey: "country") as AnyObject).1
//                    firstLineAddress = COMMON_FUNCTIONS.checkForNull(string:  value.value(forKey: "name") as AnyObject).1
//                    secondLineAddress = locality + "," + sublocality
//                    city = cityStr
//                    country = countryStr
//
//                }
//            }
//            else {
            let value = COMMON_FUNCTIONS.checkForNull(string: dic.value(forKey: "value") as AnyObject).1
            if placeHolder == "Email" {
                email = value
            }
                if placeHolder == "First Name" {
                    first_name = value
                }
                if placeHolder == "Surname" {
                    surname = value
                }
                if placeHolder == "Gender" {
                    gender = value
                }
                if placeHolder == "Date of Birth" {
                    dateOfBirth = value
                }
                if placeHolder == "Postal Code" {
                    postalCode = value
                }
                
                if placeHolder == "Date of Birth" {
                    dateOfBirth = value
                }
            
            if placeHolder == "First Line Address" {
                firstLineAddress = value
            }
            if placeHolder == "Second Line Address" {
                secondLineAddress = value
            }
            if placeHolder == "City" {
                city = value
            }
            if placeHolder == "County" {
                county = value
            }
            if placeHolder == "Postcode" {
                postalCode = value
            }
            if placeHolder == "Country" {
                country = value
            }
//            }
        }

        let params = [
            "email":email,
            "firstName": first_name,
            "surname": surname,
            "gender": gender,
            "dateOfBirth":dateOfBirth,
            "postalCode": postalCode,
            "firstLineAddress": firstLineAddress,
            "secondLineAddress": secondLineAddress,
            "city": city,
            "county": county,
            "country": country
        ]
  
        WebService.authenticationFunction()
            SVProgressHUD.show()
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.setRingNoTextRadius(14.0)
//        let strUrl = APINAME.init().user
        let strUrl = IDENTITY_BASE_URL + "/v1/profile"

//        print(BASE_URL.appending(strUrl))
        print(strUrl)
        print(params )
    
        var request = URLRequest(url: NSURL(string: strUrl)! as URL)
        print(BASE_URL.appending(strUrl))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        do
        {
            // json format
            let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let postString = NSString(data: body, encoding: String.Encoding.utf8.rawValue)
            
            print("Post Data -> \(String(describing: postString))")
            
            request.httpBody = body
            
        }
        catch let error as NSError
        {
            print(error)
        }

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        
    AF.request(strUrl, method: HTTPMethod.put, parameters: params, encoding: JSONEncoding.default, headers: headers)
        .response { (response) in
            print(response)
            print(response.response?.statusCode)
           let statusCode = response.response?.statusCode
            if (statusCode == 204) {
                SVProgressHUD.dismiss()
                self.showSuccessAlert(msg: "Profile Updated Successfully", title: "")
//                self.view.makeToast("Profile Updated Successfully", duration: 2, position: .center, title: "", image: nil, style: .init(), completion: {_ in
//                    self.navigationController?.popViewController(animated: true)
//                })
                self.navigationController?.popViewController(animated: true)
                return
            }
            else {
                SVProgressHUD.dismiss()
                COMMON_FUNCTIONS.showAlert(msg: "SERVER ERROR", title: "")
            }
        }
//        .responseData { (response:DataResponse<Data>) in
//
//        switch(response.result) {
//        case .success(_):
//            if let data = response.data
//            {
//                print(JSON(data))
//                SVProgressHUD.dismiss()
//            }
//            break
//
//        case .failure(_):
//            SVProgressHUD.dismiss()
//            break
//        }
//
//
//    }

        
    }

     func showSuccessAlert (msg:String,title:String)
    {
        let attributedString = NSAttributedString(string: msg,
                                                  attributes: [NSAttributedString.Key.font : UIFont(name: REGULAR_FONT, size: 15)!])
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.setValue(attributedString, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            return
        }))
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        
        let popPresenter = alert.popoverPresentationController
        popPresenter?.sourceView = viewController?.view
        popPresenter?.sourceRect = (viewController?.view.bounds)!
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func openActionSheet(index:Int)  {
        let dict = self.dataArray[index] as! NSDictionary
        let mutableDict = dict.mutableCopy() as! NSMutableDictionary
        let alertController = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Female", style: .default, handler: { (action) in
                print("Female")
            mutableDict.setValue("Female", forKey: "value")
            self.dataArray[index] = mutableDict
            self.tableV.reloadData()
                return
            }))
        
        alertController.addAction(UIAlertAction(title: "Male", style: .default, handler: { (action) in
                print("Male")
            mutableDict.setValue("Male", forKey: "value")
            self.dataArray[index] = mutableDict
            self.tableV.reloadData()
                return
            }))
 
        alertController.addAction(UIAlertAction(title: "Other", style: .default, handler: { (action) in
                print("Other")
            mutableDict.setValue("Other", forKey: "value")
            self.dataArray[index] = mutableDict
            self.tableV.reloadData()
                return
            }))
        
        alertController.addAction(UIAlertAction(title: "Prefer not to say", style: .default, handler: { (action) in
                print("Prefer not to say")
            mutableDict.setValue("Prefer not to say", forKey: "value")
            self.dataArray[index] = mutableDict
            self.tableV.reloadData()
                return
            }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            print("Cancel")
        }))
        
        if UIDevice().userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                 
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }

}

extension MyProfileViewController : UITableViewDelegate , UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableV {
           return dataArray.count
        }
        return googlePlacesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableV {
        let nib = UINib(nibName: "MyProfileTableViewCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "MyProfileTableViewCell")
        let cell = tableV.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell") as! MyProfileTableViewCell
        let dic = dataArray[indexPath.row] as! NSDictionary
        let placeHolderText = dic.value(forKey: "placeholder") as! String
        let image = dic.value(forKey: "image") as! UIImage
        var text = ""
        print(dic)
        if placeHolderText == "Enter your postcode..." {
            let dict = dic.value(forKey: "value") as! NSDictionary
            if dict.count > 0 {
                let firstLineAddress = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "firstLineAddress") as AnyObject).1
                let secondLineAddress = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "secondLineAddress") as AnyObject).1
                let city = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "city") as AnyObject).1
                let county = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "county") as AnyObject).1
                let postcode = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "postcode") as AnyObject).1
                let country = COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "country") as AnyObject).1
             text = "\(firstLineAddress), \(secondLineAddress), \(city), \(county), \(postcode), \(country)"
            }
            cell.addressView.isHidden = false
            cell.houseNumberTextField.text = (self.houseNumberDict.value(forKey: "value") as! String)
            cell.postcodeTextField.text = self.postcodeSearch
            print(COMMON_FUNCTIONS.checkForNull(string: dic.value(forKey: "value") as AnyObject).1)
        }
        else {
            cell.addressView.isHidden = true
            text = COMMON_FUNCTIONS.checkForNull(string: dic.value(forKey: "value") as AnyObject).1
        }
        cell.imgIcon.image = image
        cell.txtField.placeholder = placeHolderText
        cell.txtField.text = text
        cell.txtField.delegate = self
        cell.txtField.tag = indexPath.row
            
        cell.houseNumberTextField.tag = 100
        cell.postcodeTextField.tag = indexPath.row
        cell.houseNumberTextField.delegate = self
        cell.postcodeTextField.delegate = self
        
        if placeHolderText == "Gender" || placeHolderText == "Date of Birth" {
            if placeHolderText == "Date of Birth" {
                cell.expandImg.image = #imageLiteral(resourceName: "information")
                cell.cellButton.isHidden = false
            }
            else {
                cell.expandImg.image = #imageLiteral(resourceName: "expand")
                cell.cellButton.isHidden = true
                
            }

            cell.cellButton.addTarget(self, action: #selector(cellButtonClicked(_:)), for: .touchUpInside)
            
            cell.txtField.isUserInteractionEnabled = false
            cell.expandImg.isHidden = false
            cell.headerLbl.isHidden = true
            cell.reloadButton.isHidden = true
            cell.headerLblHeightConstraint.constant = 0.0
            cell.mainViewTrailingConstraint.constant = 20.0
            cell.findButtonWidthConstraint.constant = 0.0
            cell.mainViewTrailingFindButtonConstraint.constant = 0.0
        }
        else {
            cell.txtField.isUserInteractionEnabled = true
            cell.expandImg.isHidden = true
            cell.imgIcon.isHidden = false
            if placeHolderText == "Email" {
                cell.headerLbl.isHidden = false
                cell.reloadButton.isHidden = true
                cell.headerLbl.text = "General"
                cell.headerLblHeightConstraint.constant = 27.0
                cell.mainViewTrailingConstraint.constant = 20.0
                cell.findButtonWidthConstraint.constant = 0.0
                cell.mainViewTrailingFindButtonConstraint.constant = 0.0
            }
 
            
           else if placeHolderText == "Postal Code" {
                cell.headerLbl.isHidden = false
                cell.reloadButton.isHidden = false
                cell.headerLbl.text = "Delivery Address"
                cell.headerLblHeightConstraint.constant = 27.0
                cell.findButton.isHidden = false
                cell.mainViewTrailingConstraint.constant = 160.0
                cell.findButtonWidthConstraint.constant = 130.0
                cell.mainViewTrailingFindButtonConstraint.constant = 10.0
            
            cell.findButton.tag = indexPath.row
            cell.findButton.addTarget(self, action: #selector(findButtonClicked(_:)), for: .touchUpInside)
            
            }
            else {
                cell.imgIconWidthConstraint.constant = 30.0
                cell.headerLbl.isHidden = true
                cell.reloadButton.isHidden = true
                cell.headerLblHeightConstraint.constant = 0.0
                cell.findButton.isHidden = true
                cell.mainViewTrailingConstraint.constant = 20.0
                cell.findButtonWidthConstraint.constant = 0.0
                cell.mainViewTrailingFindButtonConstraint.constant = 0.0
            }
            
            if placeHolderText == "Enter your postcode..." {
//                cell.imgIcon.isHidden = true
//                cell.imgIconWidthConstraint.constant = 0.0
                cell.headerLbl.isHidden = false
                cell.reloadButton.isHidden = self.dataArray.count > 6 ? false : true
                cell.headerLbl.text = "Address"
                cell.headerLblHeightConstraint.constant = 27.0
            }
            if placeHolderText == "First Line Address" {
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0.0
                cell.headerLbl.isHidden = false
                cell.reloadButton.isHidden = self.dataArray.count > 6 ? false : true
                cell.headerLbl.text = "Address"
                cell.headerLblHeightConstraint.constant = 27.0
                cell.txtField.isUserInteractionEnabled = true
            }
            
            if placeHolderText == "Second Line Address" || placeHolderText == "City" || placeHolderText == "County" || placeHolderText == "Postcode" || placeHolderText == "Country" {
                cell.txtField.isUserInteractionEnabled = true
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0.0
            }
            else if placeHolderText == "Email" {
                cell.txtField.isUserInteractionEnabled = false
                cell.imgIcon.isHidden = false
                cell.imgIconWidthConstraint.constant = 30.0
              
            }
            if placeHolderText == "Email" {
                cell.txtField.textColor = UIColor(red: 223.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1)
            }
            else {
                cell.txtField.textColor = UIColor.black
            }
            
//            else {
//                cell.imgIcon.isHidden = false
//                cell.headerLbl.isHidden = true
//                cell.headerLblHeightConstraint.constant = 0.0
//            }
    
            if placeHolderText == "Gender" {
                cell.expandImg.isHidden = false
            }
            
            
           
            cell.reloadButton.addTarget(self, action: #selector(addressReloadButtonTapped(_:)), for: .touchUpInside)
      
        }
        cell.selectionStyle = .none
        return cell
     }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if( !(cell != nil))
            {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
                
            }
            let result = googlePlacesArray.object(at: indexPath.row) as? NSDictionary
            print(result as Any)
            let line1 = COMMON_FUNCTIONS.checkForNull(string: result?.value(forKey: "line_1") as AnyObject).1
            var post_town = COMMON_FUNCTIONS.checkForNull(string: result?.value(forKey: "post_town") as AnyObject).1
            let country = COMMON_FUNCTIONS.checkForNull(string: result?.value(forKey: "country") as AnyObject).1
            
                post_town = post_town != "" ? "\(post_town), " : post_town
                let primaryAddress = line1
                cell?.textLabel?.text  = primaryAddress
                if let aSize = UIFont(name: REGULAR_FONT, size: 16) {
                    cell?.textLabel?.font = aSize
                }

                let secondaryAddress = post_town + country
                cell?.detailTextLabel?.text = secondaryAddress
                if let aSize = UIFont(name: REGULAR_FONT, size: 12) {
                    cell?.detailTextLabel?.font = aSize
                }
            cell?.imageView?.image = #imageLiteral(resourceName: "icon-pointer")
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableV {
        
        var dic = NSDictionary.init()
        dic = dataArray[indexPath.row] as! NSDictionary
            print(dic)
        let placeHolder = dic.value(forKey: "placeholder") as! String
        DispatchQueue.main.async {
            if placeHolder == "Gender" {
                self.openActionSheet(index:indexPath.row)
            }
            else if placeHolder == "Date of Birth" {
                self.datePickerTapped()
            }
          }
        }
        
        else {
            let resultDic = googlePlacesArray.object(at: indexPath.row) as! NSDictionary
           displayLocationInfo(resultDic: resultDic)
        }

    }
    
    func displayLocationInfo(resultDic: NSDictionary)   {

        var firstLineAddress = "" , secondLineAddress = "" , city = "" , county = "" , postcode = "" , country = ""

        if resultDic.count > 0 {
            firstLineAddress = COMMON_FUNCTIONS.checkForNull(string: resultDic.value(forKey: "line_1") as AnyObject).1
            secondLineAddress = COMMON_FUNCTIONS.checkForNull(string: resultDic.value(forKey: "line_2") as AnyObject).1
            city = COMMON_FUNCTIONS.checkForNull(string: resultDic.value(forKey: "post_town") as AnyObject).1
            county = COMMON_FUNCTIONS.checkForNull(string: resultDic.value(forKey: "county") as AnyObject).1
            postcode = COMMON_FUNCTIONS.checkForNull(string: resultDic.value(forKey: "postcode") as AnyObject).1
            country = COMMON_FUNCTIONS.checkForNull(string: resultDic.value(forKey: "country") as AnyObject).1
        }

        let addressDic = NSMutableDictionary.init()
        addressDic.setObject(firstLineAddress, forKey: "firstLineAddress" as NSCopying)
        addressDic.setObject(secondLineAddress, forKey: "secondLineAddress" as NSCopying)
        addressDic.setObject(city, forKey: "city" as NSCopying)
        addressDic.setObject(county, forKey: "county" as NSCopying)
        addressDic.setObject(postcode, forKey: "postcode" as NSCopying)
        addressDic.setObject(country, forKey: "country" as NSCopying)

        self.getSeletedAddress(selectedAddress: addressDic)
        }
    
    
    @objc func cellButtonClicked(_ sender : UIButton) {
        COMMON_FUNCTIONS.showAlert(msg: "Required for age restriction purchases within the app.", title: "Warning")
    }
    
    @objc func findButtonClicked(_ sender : UIButton) {
        let dic = self.dataArray[sender.tag] as! NSDictionary
        let postalCode = dic.value(forKey: "value") as! String
        placeAutocomplete(postalCode)
    }
    
    func placeAutocomplete(_ addressStr: String?) {
        placesClient = GMSPlacesClient()
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        placesClient.findAutocompletePredictions(fromQuery: addressStr!, filter: filter, sessionToken: nil) { results, error in
            if error != nil {
                print("Autocomplete error \(error?.localizedDescription ?? "")")
                return
            }
            print(results?.count)
            if results?.count == 0 || results == nil {
                self.googlePlacesArray = [Any]() as NSArray
            } else {
                print(results! as NSArray)
                self.googlePlacesArray = [Any]() as NSArray
                self.googlePlacesArray = results! as NSArray
                
                if self.googlePlacesArray.count > 0 {
                    self.tableV.tableFooterView = self.getFooterVieww()
                }
                else {
                    self.tableV.tableFooterView = self.getFooterView()
                }

//                self.tableV.reloadData()
            }
        }
    }
    
    
    func getIdealPostCodeAddresses(_ addressStr:String) {
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "\(token_type) \(access_token)"
        ]
        print(headers)
        let api_key = "ak_kr4o7ivdsgiVt0oYtb7JpDSUak127"
        let url = "https://api.ideal-postcodes.co.uk/v1/postcodes/\(addressStr)?api_key=\(api_key)"
        var request = URLRequest(url: NSURL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
        print(url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
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
                            
                            if let results = dataDictionary["result"] {
                                print(results as! NSArray)
                                self.googlePlacesArray = [Any]() as NSArray
                                self.googlePlacesArray = results as! NSArray
                                
                                if self.googlePlacesArray.count > 0 {
                                    self.tableV.tableFooterView = self.getFooterVieww()
                                }
                                else {
                                    self.tableV.tableFooterView = self.getFooterView()
                                }
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
    
    
    
    
    func getSeletedAddress(selectedAddress: Any) {
        print(selectedAddress)
        let addressDic = selectedAddress as! NSDictionary
        var firstLineAddress = "" , secondLineAddress = "" , city = "" , county = "" , postcode = "" , country = ""
 
        firstLineAddress = addressDic.value(forKey: "firstLineAddress") as! String
        secondLineAddress = addressDic.value(forKey: "secondLineAddress") as! String
        city = addressDic.value(forKey: "city") as! String
        county = addressDic.value(forKey: "county") as! String
        postcode = addressDic.value(forKey: "postcode") as! String
        country = addressDic.value(forKey: "country") as! String
        
        let dic1:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","First Line Address"),("value",firstLineAddress))
        let dic2:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Second Line Address"),("value",secondLineAddress))
        let dic3:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","City"),("value",city))
        let dic4:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","County"),("value",county))
        let dic5:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Postcode"),("value",postcode))
        let dic6:NSDictionary = NSDictionary(dictionaryLiteral: ("image",#imageLiteral(resourceName: "postcode")),("placeholder","Country"),("value",country))
        
        self.dataArray.add(dic2)
        self.dataArray.add(dic3)
        self.dataArray.add(dic4)
        self.dataArray.add(dic5)
        self.dataArray.add(dic6)
   
        for (index,item) in dataArray.enumerated() {
            let dic = (item as! NSDictionary)
            if dic.value(forKey: "placeholder") as! String == "Enter your postcode..." {
                let mutableDict = dic.mutableCopy() as! NSMutableDictionary
                mutableDict.setValue(addressDic, forKey: "value")
//                self.dataArray[index] = mutableDict
                self.dataArray[index] = dic1
            }
            print(dataArray)
            self.tableV.tableFooterView = self.getFooterView()
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        }
    }

    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -1000
        var thousandYearsAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        var selectedDate : Date! = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"

        var dic = NSMutableDictionary.init()
        for item in self.dataArray {
             dic = (item as! NSDictionary).mutableCopy() as! NSMutableDictionary
           if dic.value(forKey: "placeholder") as! String == "Date of Birth" {
                selectedDate = formatter.date(from: dic.value(forKey: "value") as! String)
            }
            if selectedDate == nil {
                selectedDate = formatter.date(from: "1/Jan/1990")
            }
        }
//        if selectedDate != nil {
//            thousandYearsAgo = selectedDate
//        }
        
        datePicker.show("Select Date of Birth",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: thousandYearsAgo,
                        maximumDate: currentDate,
                        date:selectedDate,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MMM/yyyy"
                print(formatter.string(from: dt))
            for (index,item) in self.dataArray.enumerated() {
                let dic = (item as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if dic.value(forKey: "placeholder") as! String == "Date of Birth" {
                        dic.setValue(formatter.string(from: dt), forKey: "value")
                        self.dataArray[index] = dic
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        }
    }
    
    @objc func addressReloadButtonTapped(_ sender:UIButton) {
        self.reloadButtonTapped = true
        self.postcodeSearch = ""
  
        
        for (index,item) in self.dataArray.enumerated() {
            let dict = (item as! NSDictionary)
            let placeHolder = dict.value(forKey: "placeholder") as! String
            var mutableDict = self.userDictionaryOld.mutableCopy() as! NSMutableDictionary
            if placeHolder == "Email" {
                mutableDict.setValue(COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "value") as AnyObject).1, forKey: "email")
            }
            if placeHolder == "First Name" {
                mutableDict.setValue(COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "value") as AnyObject).1, forKey: "firstName")
            }
            if placeHolder == "Surname" {
                mutableDict.setValue(COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "value") as AnyObject).1, forKey: "surname")
            }
            if placeHolder == "Gender" {
                mutableDict.setValue(COMMON_FUNCTIONS.checkForNull(string: dict.value(forKey: "value") as AnyObject).1, forKey: "gender")
            }
            if placeHolder == "Date of Birth" {
                var dob = dict.value(forKey: "value") as! String
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MMM/yyyy"
                    let date = formatter.date(from: dob)!
                dob = formatter.string(from: date)
                   print(dob)
                dob = dob.toDateString(inputDateFormat: "dd/MMM/yyyy", ouputDateFormat: "yyyy-MM-dd")
                
                mutableDict.setValue(dob, forKey: "dateOfBirth")
            }
            self.userDictionaryOld = mutableDict
        }
        DispatchQueue.main.async {
            self.setData(response: self.userDictionaryOld)
        }
    }
    
}


extension MyProfileViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        var dic = NSDictionary()
        if textField.tag == 100 {
            dic = self.houseNumberDict
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.houseNumberDict = mutableDic
        }
        else {
            dic = dataArray[textField.tag] as! NSDictionary
        }
        let placeHolder = dic.value(forKey: "placeholder") as! String
        
        print(placeHolder)
        if (newString.count) > 1
        {
            if placeHolder == "First Name" {
                let mutableDic = dic.mutableCopy() as! NSMutableDictionary
                mutableDic.setValue(newString, forKey: "value")
                self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "Surname" {
                let mutableDic = dic.mutableCopy() as! NSMutableDictionary
                mutableDic.setValue(newString, forKey: "value")
                self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "Postal Code" {
                let mutableDic = dic.mutableCopy() as! NSMutableDictionary
                mutableDic.setValue(newString, forKey: "value")
                self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "Enter your postcode..." {
            let houseNumber = self.houseNumberDict.value(forKey: "value") as! String
            let searchStr = houseNumber != "" ? houseNumber + " " + newString :  houseNumber + newString
            print(searchStr)
            self.postcodeSearch = newString
//                self.placeAutocomplete(searchStr)
                  self.getIdealPostCodeAddresses(searchStr)
            }
           else if placeHolder == "First Line Address" {
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.dataArray[textField.tag] = mutableDic
               
            }
           else if placeHolder == "Second Line Address" {
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "City" {
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "County" {
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "Postcode" {
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.dataArray[textField.tag] = mutableDic
            }
           else if placeHolder == "Country" {
            let mutableDic = dic.mutableCopy() as! NSMutableDictionary
            mutableDic.setValue(newString, forKey: "value")
            self.dataArray[textField.tag] = mutableDic
            }
//           else if placeHolder == "House No." {
//            print(newString)
//            let mutableDic = self.houseNumberDict.mutableCopy() as! NSMutableDictionary
//            mutableDic.setValue(newString, forKey: "value")
//            self.houseNumberDict = mutableDic
//            }
            
        }
        else
        {
            
        }
        return true
    }
}
