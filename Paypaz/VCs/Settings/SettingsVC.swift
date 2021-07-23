//
//  SettingsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class SettingsVC : CustomViewController {
    
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Cart(_ sender:UIButton) {
        _ = self.pushToVC("NotificationsListVC")
    }
    @IBAction func btn_Notification(_ sender:UIButton) {
        _ = self.pushToVC("NotificationsListVC")
    }
    @IBAction func btn_AddBank(_ sender:UIButton) {
        _ = self.pushToVC("AddBankAccountVC")
    }
    @IBAction func btn_AddCardDetails(_ sender:UIButton) {
        if let cardVC = self.pushToVC("CreditDebitCardVC") as? CreditDebitCardVC {
            cardVC.isAddingNewCard = false
        }
    }
    @IBAction func btn_TermsPolicies(_ sender:UIButton) {
        _ = self.pushToVC("TermsPoliciesVC")
    }
    @IBAction func btn_ContactUs(_ sender:UIButton) {
        _ = self.pushToVC("ContactUsVC")
    }
    @IBAction func btn_ChangePassword(_ sender:UIButton) {
        _ = self.pushToVC("ChangePasswordVC")
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
