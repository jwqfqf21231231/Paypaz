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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPopupForPaymentSuccess(notification:)), name: NSNotification.Name("ShowPopUp"), object: nil)
    }
    
    @objc func showPopupForPaymentSuccess(notification: Notification)
    {
        let message = notification.userInfo?["Message"] as? String ?? ""
        self.view.makeToast(message)
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_SideDrawer(_ sender:UIButton) {
        
        self.sideMenuController?.toggleLeftView()
    }
    @IBAction func btn_Cart(_ sender:UIButton) {
        _ = self.pushVC("MyCartVC")
    }
    @IBAction func btn_Notification(_ sender:UIButton) {
        _ = self.pushVC("NotificationsListVC")
    }
    
    @IBAction func btn_PaypazSecureMoney(_ sender:UIButton) {
        _ = self.pushVC("WalletVC")
    }
    @IBAction func btn_Payment(_ sender:UIButton) {
        _ = self.pushVC("PaymentTypeVC")
    }
    @IBAction func btn_Event(_ sender:UIButton) {
        _ = self.pushVC("EventVC")
    }
}
