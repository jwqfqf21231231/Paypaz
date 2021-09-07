//
//  CalendarCell.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CalendarCell : UICollectionViewCell {
    
    @IBOutlet weak var lbl_day  : UILabel!
    @IBOutlet weak var lbl_date : UILabel!
    @IBOutlet weak var bgView   : RoundView!
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                self.bgView.backgroundColor = UIColor(named: "GreenColor")
                self.lbl_day.textColor      = UIColor.white
                self.lbl_date.textColor     = UIColor.white
                
            } else {
                self.bgView.backgroundColor = UIColor(named: "LightBluish") ?? UIColor.white
                self.lbl_day.textColor      = UIColor.black
                self.lbl_date.textColor     = UIColor.black
            }
        }
    }
    
    
}

