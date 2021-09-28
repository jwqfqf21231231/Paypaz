//
//  PayAmountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class PayAmountVC : CustomViewController {
    @IBOutlet weak var btn_PayByPaypaz : RoundButton!
    @IBOutlet weak var btn_PayByQR     : RoundButton!
    @IBOutlet weak var btn_PayByBank   : RoundButton!
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
        }
    }
    @IBAction func btn_PayByPaypaz(_ sender:UIButton) {
        if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
            vc.selectedPayType = .paypaz
        }
    }
    @IBAction func btn_PayByQRCode(_ sender:UIButton) {
        if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
            vc.selectedPayType = .QRCode
        }
    }
    @IBAction func btn_PayByBankAcc(_ sender:UIButton) {
        if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
            vc.selectedPayType = .BankAcc
        }
    }
    
}

