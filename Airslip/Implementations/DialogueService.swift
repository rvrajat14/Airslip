//
//  AlertDialogue.swift
//  Airslip
//
//  Created by Graham Whitehouse on 03/08/2021.
//

import Foundation
import SVProgressHUD

class DialogueService : NSObject, DialogueServiceProtocol {

    private var progressShown: Bool = false
    
    func showProgress() {
        
        if progressShown {
            return
        }
        
        SVProgressHUD .show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(14.0)
        
        progressShown = true
    }
    
    func hideProgress() {
        SVProgressHUD.dismiss()
        
        progressShown = false
    }
    
    func displayNoConnection() {
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
           
        }))
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        
        let popPresenter = alert.popoverPresentationController
        popPresenter?.sourceView = viewController?.view
        popPresenter?.sourceRect = (viewController?.view.bounds)!
        viewController?.present(alert, animated: true, completion: nil)
    }
}
