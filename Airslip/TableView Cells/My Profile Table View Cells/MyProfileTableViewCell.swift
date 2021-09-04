//
//  MyProfileTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 25/02/21.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var expandImg: UIImageView!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var imgIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLblHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var findButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewTrailingFindButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var houseNumberView: UIView!
    @IBOutlet weak var postcodeView: UIView!
    @IBOutlet weak var reloadButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.mainView.layer.borderColor = UIColor(red: 192.0/255.0, green: 191.0/255.0, blue: 200.0/255.0, alpha: 0.5).cgColor
        
        self.mainView.layer.borderColor = UIColor(red: 223.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 0.5).cgColor
        self.houseNumberView.layer.borderColor = UIColor(red: 223.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 0.5).cgColor
        self.postcodeView.layer.borderColor = UIColor(red: 223.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 0.5).cgColor

        
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.cornerRadius = 8
        self.houseNumberView.layer.borderWidth = 1
        self.houseNumberView.layer.cornerRadius = 8
        self.postcodeView.layer.borderWidth = 1
        self.postcodeView.layer.cornerRadius = 8
        
        self.findButton.layer.cornerRadius = 5
        self.findButton.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        let color = UIColor(red: 223.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1)
        let Placeholder = txtField.placeholder ?? ""
        txtField.attributedPlaceholder = NSAttributedString(string: Placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        let Placeholder1 = houseNumberTextField.placeholder ?? ""
        houseNumberTextField.attributedPlaceholder = NSAttributedString(string: Placeholder1, attributes: [NSAttributedString.Key.foregroundColor : color])
        let Placeholder2 = postcodeTextField.placeholder ?? ""
        postcodeTextField.attributedPlaceholder = NSAttributedString(string: Placeholder2, attributes: [NSAttributedString.Key.foregroundColor : color])

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
