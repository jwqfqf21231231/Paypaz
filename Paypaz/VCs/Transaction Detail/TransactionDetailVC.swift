//
//  TransactionDetailVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class TransactionDetailVC : CustomViewController {

//MARK:- --- View Life Cycle ----
override func viewDidLoad() {
    super.viewDidLoad()

 
    }
    
    

//MARK:- --- Action ----
@IBAction func btn_Back(_ sender:UIButton) {
    self.navigationController?.popViewController(animated: true)
}
    @IBAction func btn_QRCode(_ sender:UIButton) {
         _ = self.pushVC("ScanQRCodeVC")
    }
}
