//
//  AllProductsCell.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class AllProductsCell: UITableViewCell {

    @IBOutlet weak var img_ProductPic : UIImageView!
    @IBOutlet weak var lbl_ProductName : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    @IBOutlet weak var lbl_ProductDescription : UILabel!
    @IBOutlet weak var btn_Edit : UIButton!
    @IBOutlet weak var btn_Delete : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
