//
//  MemberCell.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MemberCell : UITableViewCell {

    @IBOutlet weak var btn_tick : UIButton!
    @IBOutlet weak var contactName_lbl : UILabel!
    @IBOutlet weak var contactNo_lbl : UILabel!
    @IBOutlet weak var contactPic_img : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}