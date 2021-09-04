//
//  UserDataClass.swift
//  Laundrit
//
//  Created by Kishore on 27/09/18.
//  Copyright © 2018 Kishore. All rights reserved.
//

import UIKit

class UserDataClass: NSObject, NSCoding{

    var user_email_id:String!
    
    
    init(user_email_id: String) {

        self.user_email_id = user_email_id
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let user_email_id = aDecoder.decodeObject(forKey: "user_email_id") as! String
        
        
        self.init(user_email_id: user_email_id)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_email_id, forKey: "user_email_id")
    }
 
}

