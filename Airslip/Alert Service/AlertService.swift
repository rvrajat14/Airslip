//
//  AlertService.swift
//  Airslip
//
//  Created by Rajat Verma on 05/07/21.
//

import UIKit

class AlertService {
    
    func alert(title:String, message:String, buttonTitle:String, attributedMessage:NSAttributedString?) -> AlertViewController{
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertVC.alertTitle = title
        alertVC.alertMessage = message
        alertVC.attributedMessage = attributedMessage
        alertVC.alertButtonTitle = buttonTitle
        return alertVC
    }
}
