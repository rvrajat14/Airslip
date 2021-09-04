//
//  AccountTypeTableViewCell.swift
//  Airslip
//
//  Created by Rajat Verma on 22/06/21.
//

import UIKit

class AccountTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func layoutSubviews() {
          super.layoutSubviews()
        SHADOW_EFFECT.makeBottomShadow(forView: self.mainView, shadowHeight: 10, top_shadow: true)
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
