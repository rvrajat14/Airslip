//
//  BanksCollectionViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 11/02/21.
//

import UIKit

class BanksCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
//        SHADOW_EFFECT.makeBottomShadow(forView: self.mainView,top_shadow: true)
    }

}
