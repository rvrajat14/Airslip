//
//  AccountsTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 12/02/21.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var institutionIcon: UIImageView!
    @IBOutlet weak var accountNicknameLbl: UILabel!
    @IBOutlet weak var sortCodeLbl: UILabel!
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var currencyCodeLbl: UILabel!
    @IBOutlet weak var accountNocknameTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
          super.layoutSubviews()
//        SHADOW_EFFECT.makeBottomShadow(forView: self.mainView, shadowHeight: 10, top_shadow: true)
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
