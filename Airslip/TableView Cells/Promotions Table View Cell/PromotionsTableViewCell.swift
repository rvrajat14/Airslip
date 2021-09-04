//
//  PromotionsTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 20/02/21.
//

import UIKit

class PromotionsTableViewCell: UITableViewCell {

    @IBOutlet weak var promotionItem: UILabel!
    @IBOutlet weak var promotionDescription: UILabel!
    @IBOutlet weak var promotionImage: UIImageView!
    @IBOutlet weak var merchantWebsiteUrl: UILabel!
    @IBOutlet weak var merchantWebsiteUrlButton: UIButton!
    @IBOutlet weak var promotionButton: UIButton!
    
    @IBOutlet weak var promotionItemHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var promotionDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var merchantWebsiteUrlLblHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var promotionsButtonView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        SHADOW_EFFECT.makeBottomShadow(forView: self.promotionsButtonView)
        self.promotionsButtonView.layer.cornerRadius = 5
        self.promotionsButtonView.layer.masksToBounds = true
    }
    
}
