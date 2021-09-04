//
//  NewTransactionsTableViewCell.swift
//  Airslip
//
//  Created by Rajat Verma on 24/06/21.
//

import UIKit

class NewTransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableV: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newTransactionsLbl: UILabel!
    @IBOutlet weak var newTransactionsLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noTransactionsLbl: UILabel!
    @IBOutlet weak var noTransactionsLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gettingTransactionsLoaderView: UIView!
    @IBOutlet weak var loader: UIImageView!
    
    
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
