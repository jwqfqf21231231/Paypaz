//
//  HomeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class HomeVC : CustomViewController {

    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

     
        }
        
    

    //MARK:- --- Action ----
    @IBAction func btn_SideDrawer(_ sender:UIButton) {
        self.sideMenuController?.toggleLeftView()
    }
    @IBAction func btn_Cart(_ sender:UIButton) {
        _ = self.pushToVC("MyCartVC")
    }
    @IBAction func btn_Notification(_ sender:UIButton) {
        _ = self.pushToVC("NotificationsListVC")
    }
    
    @IBAction func btn_PaypazSecureMoney(_ sender:UIButton) {
        _ = self.pushToVC("WalletVC")
    }
    @IBAction func btn_Payment(_ sender:UIButton) {
       _ = self.pushToVC("PaymentTypeVC")
    }
    @IBAction func btn_Event(_ sender:UIButton) {
        _ = self.pushToVC("EventVC")
    }
}
