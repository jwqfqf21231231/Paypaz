//
//  BuyEventTblCell.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class BuyEventTblCell : UITableViewCell {
    
    @IBOutlet weak var img_event      : RoundImage!
    @IBOutlet weak var txt_eventName  : UILabel!
    @IBOutlet weak var txt_personName : UILabel!
    @IBOutlet weak var txt_eventPrice : UILabel!
    @IBOutlet weak var btn_addToCart  : UIButton!
    @IBOutlet weak var btn_Buy        : UIButton!
    @IBOutlet weak var btn_fav        : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
