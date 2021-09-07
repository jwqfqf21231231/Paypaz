//
//  InviteCell.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class InviteCell : UITableViewCell {

    @IBOutlet weak var btn_accept  : RoundButton!
    @IBOutlet weak var btn_reject  : RoundButton!
    @IBOutlet weak var txt_message : UILabel!
    @IBOutlet weak var img_InviteePic : UIImageView!
    
   
    override func prepareForReuse() {
        super.prepareForReuse()
        self.txt_message.attributedText = self.setAttributedTxt()
    }
    func setCellData(){
        
    }
    private func setAttributedTxt() -> NSMutableAttributedString{
        
        let quote = "Joshua Rawson Invites You for Event consectetur adipiscing"
       
        let firstAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Segoe UI Bold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(named: "BlueColor") ?? .blue]
        let secondAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Segoe UI", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(named: "BlueColor") ?? .blue]//

        let firstString  = NSMutableAttributedString(string: "Joshua Rawson ", attributes: firstAttributes)
        let secondString = NSMutableAttributedString(string: "Invites You ", attributes: secondAttributes)
        let thirdString  = NSMutableAttributedString(string: "for Event consectetur adipiscing", attributes: firstAttributes)

        firstString.append(secondString)
        firstString.append(thirdString)
        
        return firstString
    }
}
