//
//  PaymentTypeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class PaymentTypeVC: CustomViewController {
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK:- --- Action ----
    @IBAction func btn_LocalPayment(_ sender:UIButton) {
//        if let req_payAmountVC = self.pushVC("RequestPayAmountVC") as? RequestPayAmountVC {
//            req_payAmountVC.selectedPaymentType = .local
//        }
            if let contacts = self.pushVC("ContactListVC") as? ContactListVC {
                contacts.isLocalContactSelected = true
            }
    }
    @IBAction func btn_GlobalPayment(_ sender:UIButton) {
//        if let req_payAmountVC = self.pushVC("RequestPayAmountVC") as? RequestPayAmountVC {
//            req_payAmountVC.selectedPaymentType = .global
//        }
           if let contacts = self.pushVC("ContactListVC") as? ContactListVC {
                contacts.isLocalContactSelected = false
            }
    }
    
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
