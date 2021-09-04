//
//  ManualAndTutorialTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 11/03/21.
//

import UIKit

class ManualAndTutorialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var titleTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
          super.layoutSubviews()
        SHADOW_EFFECT.makeBottomShadow(forView: self.mainView, shadowHeight: 10, top_shadow: true)
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
