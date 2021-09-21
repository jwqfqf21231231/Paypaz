//
//  ProductTableCell.swift
//  Paypaz
//
//  Created by iOSDeveloper on 20/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
class ProductTableCell : UITableViewCell {
    @IBOutlet weak var img_Product          : UIImageView!
    @IBOutlet weak var lbl_ProductName      : UILabel!
    @IBOutlet weak var lbl_Description      : UILabel!
    @IBOutlet weak var lbl_Price            : UILabel!
    @IBOutlet weak var btn_Delete           : UIButton!
    @IBOutlet weak var btn_Edit             : UIButton!
    @IBOutlet weak var btn_AddProduct       : UIButton!
    @IBOutlet weak var btn_DeleteProduct    : UIButton!
    @IBOutlet weak var lbl_ProductCount     : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 5))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
