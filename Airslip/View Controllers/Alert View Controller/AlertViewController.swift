//
//  AlertViewController.swift
//  Airslip
//
//  Created by Rajat Verma on 05/07/21.
//

import UIKit

class AlertViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var titleLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    var alertTitle = ""
    var alertMessage = ""
    var alertButtonTitle = ""
    var alertCancelButtonTitle = ""
    var attributedMessage : NSAttributedString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView() {
        titleLbl.text = alertTitle
        messageLbl.text = alertMessage
        allowButton.setTitle(alertButtonTitle, for: .normal)
        if alertMessage == "" {
            messageLbl.attributedText = attributedMessage
        }
        if alertTitle == "" {
            self.titleLblHeightConstraint.constant = 15
        }
        self.mainView.layer.cornerRadius = 10.0
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        isNewUser = false
        biometricOn = false
        COMMON_FUNCTIONS.updateFaceId()
        return
    }
    
    @IBAction func allowButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        isNewUser = true
        biometricOn = true
        COMMON_FUNCTIONS.updateFaceId()
        return
        
    }
    
}
