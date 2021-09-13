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
    @IBOutlet weak var btn_PeopleInvited : UIButton!
    @IBOutlet weak var btn_ShareEvent : UIButton!
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10))
//    }
}
