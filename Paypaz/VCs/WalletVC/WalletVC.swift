//
//  WalletVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class WalletVC : CustomViewController {
    
    //MARK:- ----
    @IBOutlet weak var tableViewTransactions : UITableView! {
        didSet {
            self.tableViewTransactions.dataSource = self
            self.tableViewTransactions.delegate   = self
        }
    }
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK:- ---- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_PayRequest(_ sender:UIButton) {
       // _ = self.pushToVC("ContactListVC")
         _ = self.pushVC("PaymentTypeVC")
    }
    @IBAction func btn_AddMoney(_ sender:UIButton) {
        if let popupVC = self.presentPopUpVC("AddMoneyPopupVC", animated: true) as? AddMoneyPopupVC {
            popupVC.delegate = self
        }
    }
    
    @IBAction func btn_SendToBank(_ sender:UIButton) {
        _ = self.pushVC("SendToBankVC")
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension WalletVC : AddMoneyPopupDelegate {
    func isSelectedType(bank: Bool) {
        if bank {
             _ = self.pushVC("AddBankDetailsVC")
        } else {
             _ = self.pushVC("AddCardDetailsVC")
        }
    }
}
