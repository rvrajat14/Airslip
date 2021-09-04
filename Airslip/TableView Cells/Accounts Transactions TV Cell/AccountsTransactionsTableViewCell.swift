//
//  AccountsTransactionsTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 16/02/21.
//

import UIKit

class AccountsTransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var merchantLogo: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var svgIconView: UIView!
    
    @IBOutlet weak var mainViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateWidthLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var merchantNameCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var merchantNameTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var merchantNameWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var receiptIcon: UIImageView!
    @IBOutlet weak var bankIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
