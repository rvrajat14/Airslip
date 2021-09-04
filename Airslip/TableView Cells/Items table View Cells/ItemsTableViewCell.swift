//
//  ItemsTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 19/02/21.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemHeaderView: UIView!
    @IBOutlet weak var itemheaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ItemShortView: UIView!
    @IBOutlet weak var productItem: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var itemFullView: UIView!
    @IBOutlet weak var itemLongViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandViewToggleButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productWarrantyExpiryDateTime: UILabel!
    @IBOutlet weak var productItemHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var twoYearsWarrantyLbl: UILabel!
    @IBOutlet weak var expiresLbl: UILabel!
    @IBOutlet weak var productWarrantyLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var expiresLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var twoYearsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandImage: UIImageView!
    @IBOutlet weak var sepratorView1: UIView!
    @IBOutlet weak var sepratorView2: UIView!
    
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var productDescriptionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateMeViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    var isImageSizeChanged = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sepratorView1.backgroundColor = COMMON_FUNCTIONS.hexStringToUIColor(hex: "#EEEEEE")
        self.sepratorView2.backgroundColor = COMMON_FUNCTIONS.hexStringToUIColor(hex: "#EEEEEE")
        self.productDescription.layer.borderColor = UIColor.black.cgColor
        self.productDescription.layer.borderWidth = 1
        
//        self.productImage.layer.borderColor = UIColor.black.cgColor
//        self.productImage.layer.borderWidth = 1
        
        self.productDescriptionTextView.textContainerInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.productDescriptionTextView.textContainer.lineFragmentPadding = 0
     
    }
    
    override func layoutSubviews() {
//        self.productDescription.padding = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
