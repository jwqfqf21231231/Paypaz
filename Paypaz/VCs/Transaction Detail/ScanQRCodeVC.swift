//
//  ScanQRCodeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ScanQRCodeVC: CustomViewController {
    
    @IBOutlet weak var userPic : UIImageView!
    @IBOutlet weak var userNameLabel : UILabel!
    var userName : String?
    var userImage :UIImage?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = userName ?? ""
        userPic.image = userImage ?? UIImage(named: "place_holder")
    }

    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
