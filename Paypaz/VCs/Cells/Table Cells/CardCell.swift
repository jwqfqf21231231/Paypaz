//
//  CardCell.swift
//  Paypaz
//
//  Created by MAC on 29/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardNumberLabel : UILabel!
    @IBOutlet weak var carHolderNameLabel : UILabel!
    @IBOutlet weak var cardImage : UIImageView!
    @IBOutlet weak var primaryLabel : UILabel!
    @IBOutlet weak var primaryLabelHeight : NSLayoutConstraint!
    @IBOutlet weak var deleteButton : UIButton!
}
