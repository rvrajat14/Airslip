//
//  ManageTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 12/02/21.
//

import UIKit

class ManageTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var switchWidthConstraint: NSLayoutConstraint!
    
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

        // Configure the view for the selected state
    }
    
}
