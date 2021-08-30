//
//  MyEventsCell.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyEventsCell : UITableViewCell {

    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var lbl_EventName : UILabel!
    @IBOutlet weak var lbl_EventTime : UILabel!
    @IBOutlet weak var lbl_EventAddress : UILabel!
    @IBOutlet weak var btn_More   : UIButton!
    @IBOutlet weak var lbl_PeopleInvited : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
