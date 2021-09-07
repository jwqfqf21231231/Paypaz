//
//  FavouriteCell.swift
//  Paypaz
//
//  Created by mac on 27/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var txt_EventName : UILabel!
    @IBOutlet weak var txt_EventDate : UILabel!
    @IBOutlet weak var txt_Location : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
