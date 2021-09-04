//
//  WebService.swift
//  Dry Clean City
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 Kishore. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class WebService: NSObject {

    
    class func showAlert ()
    {
        let alert = UIAlertController(title: nil, message: " \n\n\n\n\n\n\n", preferredStyle: .alert)
        let uiView = UIView(frame: CGRect(x: alert.view.frame.origin.x, y: 15, width: 250, height: 150))
      
        let imageV = UIImageView(frame: CGRect(x: uiView.center.x - 40, y: 10, width: 100, height: 90))
        
        imageV.image = #imageLiteral(resourceName: "internet-placeholder")
        imageV.contentMode = .scaleAspectFill
        uiView.addSubview(imageV)
        let msgLbl = UILabel(frame: CGRect(x: uiView.frame.origin.x + 20, y: imageV.frame.size.height + 30, width: 230, height: 50))
        msgLbl.font = UIFont(name: REGULAR_FONT, size: 17)
        msgLbl.textAlignment = .center
        msgLbl.numberOfLines = 2
        msgLbl.textColor = UIColor(red: 108/255.0, green: 108/255.0, blue: 108/255.0, alpha: 1)
        msgLbl.text = "Check the Internet connection"
        let fonD:UIFontDescriptor = msgLbl.font.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)!
        
        msgLbl.font = UIFont(descriptor: fonD, size: 17)
        uiView.addSubview(msgLbl)
        alert.view.addSubview(uiView)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
           return
        }))
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        
        let popPresenter = alert.popoverPresentationController
        popPresenter?.sourceView = viewController?.view
        popPresenter?.sourceRect = (viewController?.view.bounds)!
        viewController?.present(alert, animated: true, completion: nil)
    }
    
  
    class func requestGetUrlForCheckPort(strURL:String,is_loader_required:Bool, success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
        
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
            
            
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
            
            do
            {
                // json format
                let body = try JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
                
                let postString = NSString(data: body, encoding: String.Encoding.utf8.rawValue)
                
                print("Post Data -> \(String(describing: postString))")
                
            }
            catch let error as NSError
            {
                print(error)
            }
            
            let headers = [
            
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
                
            ]
            print(headers)
            let BaseUrl = BASE_URL
          
            authenticationFunction()
            
            var request = URLRequest(url: NSURL(string: BaseUrl.appending(strURL))! as URL)
            print(BaseUrl.appending(strURL))
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
                            
                            if let dataDictionary = JSON(data).dictionaryObject
                            {
                                success(dataDictionary as NSDictionary)
                            }
                            if let dataArray = JSON(data).arrayObject
                            {
                                success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                            }
                            else
                            {
                                
                            }
                        }
                        break
                        
                    case .failure(_):
                        SVProgressHUD.dismiss()
                        print(response.error as Any)
                        let viewController = UIApplication.shared.keyWindow?.rootViewController
                        viewController?.view.makeToast(response.error?.localizedDescription, duration: 1.0, position: .bottom)
                        failure(response.error.debugDescription )
                        break
                    }
            }
        }
        else
        {
            showAlert()
            return
        }
        
    }

    class func requestGetUrl(strURL:String, params:NSDictionary,is_loader_required:Bool, success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
        
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
           
        print(BASE_URL.appending(strURL))
            
           authenticationFunction()
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
            
            var request = URLRequest(url: NSURL(string: BASE_URL.appending(strURL).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
            print(BASE_URL.appending(strURL))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
   
            AF.request(request)
                .response { (response) in
                    print(response.response?.statusCode)
                   let statusCode = response.response?.statusCode
                    
                    if (statusCode == 404) || (strURL.contains("logout") && statusCode == 200) {
                        NotificationCenter.default.post(name: NSNotification.Name.init("LogoutNotification"), object: nil)
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
//                            if res == nil {
//                                NotificationCenter.default.post(name: NSNotification.Name.init("LogoutNotification"), object: nil)
//                            }
                            
                            if let dataDictionary = JSON(data).dictionaryObject
                            {
                                    success(dataDictionary as NSDictionary)
                            }
                            if let dataArray = JSON(data).arrayObject
                            {
                                success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                            }
                        }
                        break
                        
                    case .failure(_):
                        SVProgressHUD.dismiss()
                        failure(response.error.debugDescription )
                        print(response.error.debugDescription)
                        break
                    }
            }
        }
            
        else
        {
            showAlert()
            return
        }
    }
    
    
    
    
    class func requestPostUrl(strURL:String, params:NSDictionary,is_loader_required:Bool, success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
        
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
        
        
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
        
            do
            {
                // json format
                let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
                let postString = NSString(data: body, encoding: String.Encoding.utf8.rawValue)
                
                print("Post Data -> \(String(describing: postString))")
                
            }
            catch let error as NSError
            {
                print(error)
            }
            
            authenticationFunction()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
        print(BASE_URL.appending(strURL))
        AF.request(BASE_URL.appending(strURL), method: HTTPMethod.post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in
      

            switch(response.result) {
            case .success(_):
                if let data = response.data
                {
                     SVProgressHUD.dismiss()
                    
                    
                    if let dataDictionary = JSON(data).dictionaryObject
                    {
                        if strURL.contains("oauth/token")
                        {
                            success(dataDictionary as NSDictionary)
                        }
                        else
                        {
                                success(dataDictionary as NSDictionary)
                        }
                    }
                    if let dataArray = JSON(data).arrayObject
                    {
                        success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                    }
                   
                }
                break
                
            case .failure(_):
                 SVProgressHUD.dismiss()
                failure(response.error.debugDescription )
                break
            }
            
            
        }
        }
            
        else
        {
            showAlert()
            return
        }
    }
    
    
    
    class func requestDelUrl(strURL:String,is_loader_required:Bool, success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
        
        
        
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
          
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
        
            
        
        print(BASE_URL.appending(strURL))
            authenticationFunction()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
            
        AF.request(BASE_URL.appending(strURL), method: HTTPMethod.delete, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.data
                {
                    print(data)
                    SVProgressHUD.dismiss()
                    
                    
                    if let dataDictionary = JSON(data).dictionaryObject
                    {
                            success(dataDictionary as NSDictionary)
                    }
                    if let dataArray = JSON(data).arrayObject
                    {
                        success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                    }
                    
                }
                break
                
            case .failure(_):
                SVProgressHUD.dismiss()
                failure(response.error.debugDescription )
                break
            }
            
        }
        }
            
        else
        {
            showAlert()
            return
        }
        
    }
    
    
    
    class func requestPostUrlWithJSONDictionaryParameters(strURL:String,is_loader_required:Bool, params:[String:Any], success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
      
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            
            
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
        
        print(BASE_URL.appending(strURL))
        print(params )
            authenticationFunction()
       
        do
        {
            // json format
            let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let postString = NSString(data: body, encoding: String.Encoding.utf8.rawValue)
            
            print("Post Data -> \(String(describing: postString))")
            
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
            
        AF.request(BASE_URL.appending(strURL), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in
            
            
            switch(response.result) {
            case .success(_):
                if let data = response.data
                {
                    print(JSON(data))
                     SVProgressHUD.dismiss()
   
                    if let dataDictionary = JSON(data).dictionaryObject
                    {
                            success(dataDictionary as NSDictionary)
                    }
                    if let dataArray = JSON(data).arrayObject
                    {
                        success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                    }
                }
                break
                
            case .failure(_):
                 SVProgressHUD.dismiss()
                failure(response.error.debugDescription )
                break
            }
            
            
        }
        }
            
        else
        {
            showAlert()
            return
        }
    }
    
    
    
    
    class func requestPUTUrlWithJSONArrayParameters(strURL:String,is_loader_required:Bool, params:NSArray, success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
        
        
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            
        
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
        
         print(BASE_URL.appending(strURL))
            authenticationFunction()
            
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "\(token_type) \(access_token)"
            ]
            print(headers)
            
        var request = URLRequest(url: NSURL(string: BASE_URL.appending(strURL))! as URL)
        print(BASE_URL.appending(strURL))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
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
                                success(dataDictionary as NSDictionary)
                        }
                        if let dataArray = JSON(data).arrayObject
                        {
                            success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                        }
                    }
                    break
                    
                case .failure(_):
                     SVProgressHUD.dismiss()
                    failure(response.error.debugDescription )
                     print(response.error.debugDescription)
                    break
                }
        }
        }
            
        else
        {
            showAlert()
            return
        }
    }
    
    
    
    class func requestPUTUrlWithJSONDictionaryParameters(strURL:String,is_loader_required:Bool, params:[String:Any], success:@escaping (_ response:NSDictionary) -> (), failure:@escaping (String) -> ()) {
        
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            
            
            if is_loader_required
            {
                SVProgressHUD .show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setRingNoTextRadius(14.0)
            }
        
        print(BASE_URL.appending(strURL))
        print(params )
            authenticationFunction()
        
            var request = URLRequest(url: NSURL(string: BASE_URL.appending(strURL))! as URL)
            print(BASE_URL.appending(strURL))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(token_type) \(access_token)", forHTTPHeaderField: "Authorization")
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
                "Content-Type": "application/json"
            ]
            print(headers)
            
        AF.request(BASE_URL.appending(strURL), method: HTTPMethod.put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { (response:DataResponse<Data,AFError>) in

            switch(response.result) {
            case .success(_):
                if let data = response.data
                {
                    print(JSON(data))
                    SVProgressHUD.dismiss()
                    
                    if let dataDictionary = JSON(data).dictionaryObject
                    {
                            success(dataDictionary as NSDictionary)
                    }
                    if let dataArray = JSON(data).arrayObject
                    {
                        success(NSDictionary(dictionaryLiteral:  ("data",dataArray)))
                    }
                }
                break
                
            case .failure(_):
                SVProgressHUD.dismiss()
                failure(response.error.debugDescription )
                break
            }
        }
        }
            
        else
        {
            showAlert()
            return
        }
    }

    
    class func authenticationFunction()
    {
        
        if  userDefaults.value(forKey: "expireDate") != nil
        {
         
            if  UserDefaults.standard.value(forKey: "expireDate") != nil
            {
            let currentDate = Date()
            let expireDate = (UserDefaults.standard.value(forKey: "expireDate") as! Date)
            
            if UserDefaults.standard.value(forKey: "refresh_token") != nil
            {
                refresh_token = (UserDefaults.standard.value(forKey: "refresh_token") as! String)
            }
            
            if currentDate > expireDate
            {
               
                let strUrl = IDENTITY_BASE_URL + "/v1/identity/refresh"
                        let param = ["refreshToken":refresh_token,
                                     "deviceId": deviceId]
                        
                        var request = URLRequest(url: NSURL(string:strUrl)! as URL)
                        print(strUrl)
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                       request.setValue("\(token_type) \(access_token)", forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        
                        do
                        {
                            // json format
                            let body = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
                            
                            let postString = NSString(data: body, encoding: String.Encoding.utf8.rawValue)
                            
                            print("Post Data -> \(String(describing: postString))")
                            
                            request.httpBody = body
                            
                        }
                        catch let error as NSError
                        {
                            print(error)
                        }
                        
                        
                        var response: URLResponse?
                         var resultDictionary: NSDictionary!
                        do
                        {
                           let urlData = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
                            resultDictionary = try (JSONSerialization.jsonObject(with: urlData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary)
                            print(resultDictionary)
                            
                            if resultDictionary["errors"] != nil
                            {
                                  NotificationCenter.default.post(name: NSNotification.Name.init("LogoutNotification"), object: nil)
                             return
                            }
                            else
                            {
                                access_token = (resultDictionary["bearerToken"] as! String)
                                refresh_token = (resultDictionary["refreshToken"] as! String)
                                userDefaults.setValue(access_token, forKey: "access_token")
                                userDefaults.setValue(refresh_token, forKey: "refresh_token")
                                if let expiry = resultDictionary["expiry"] {
                                    let expireTime = (expiry as! NSNumber)
                                    let expireDate = Date(milliseconds: Int64(truncating: expireTime))
                                    userDefaults.setValue(expireDate, forKey: "expireDate")
                                }
                                 return
                            }
                        }
                        catch
                        {
                            
                        }
                }
                return
            }
        }
    }
}

class APINAME {
 
  let register = "/v1/authenticate/register"
  let login = "/v1/authenticate/login"
  let logout = "/v1/authenticate/logout"
  let signin_google = "/v1/authenticate/signin-google"
  let facebook_login = "/v1/authenticate/facebook-login"
  let facebook_authorized = "/v1/authenticate/facebook-authorized"
  let forgot_password = "/v1/authenticate/forgot-password"
  let reset_password = "/v1/authenticate/reset-password"
  let contents = "/v1/contents"
  let banks = "/v1/banks"
  let accounts = "/v1/accounts"
  let profile = "/api/profile"
  let scan = "/api/scan"
  let history = "/api/history"
  let save_receipt = "/api/save_receipt"
  let register_device_token = "/api/register_device_token"
  let get_transactions = "/api/get_transactions"
  let get_merchants = "/api/get_merchants"
  let unsupported_merchants = "/v1/admin/merchants"
  let get_manuals = "/v1/manuals"
  let all_transactions = "/v1/transactions"
    
  let user = "/v1/profile"
  let get_user_photo = "/v1/profile/photo"
  let faceIdApi = "/v1/identity/biometric"
  let refreshTokenApi = "/v1/identity/refresh"
}


class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
