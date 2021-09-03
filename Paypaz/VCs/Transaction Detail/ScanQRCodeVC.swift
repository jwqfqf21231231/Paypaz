//
//  ScanQRCodeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ScanQRCodeVC: CustomViewController {
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
