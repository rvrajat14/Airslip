//
//  BlogsTableViewCell.swift
//  Airslip
//
//  Created by Rahul Verma on 19/02/21.
//

import UIKit

class BlogsTableViewCell: UITableViewCell {

    @IBOutlet weak var blogsDescription: UILabel!
    @IBOutlet weak var blogsUrl: UILabel!
    @IBOutlet weak var blogsDescription2: UILabel!
    @IBOutlet weak var blogsUrl2: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var vatValue: UILabel!
    @IBOutlet weak var posProvider: UILabel!
    @IBOutlet weak var transactionQRLbl: UILabel!
    @IBOutlet weak var transactionQrImage: UIImageView!
    @IBOutlet weak var blogDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blogUrlHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blogDescription2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blogUrl2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var blogUrlButton: UIButton!
    @IBOutlet weak var blogUrl2Button: UIButton!
    @IBOutlet weak var documentButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sepratorView.backgroundColor = COMMON_FUNCTIONS.hexStringToUIColor(hex: "#EEEEEE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
