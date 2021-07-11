//
//  AddBankDetailsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class AddBankDetailsVC : CustomViewController {
   
   //MARK:- ----
   
   
   //MARK:- ---- View Life Cycle ----
   override func viewDidLoad() {
       super.viewDidLoad()
       
       
   }
   
   
   //MARK:- ---- Action ----
   @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
   }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if let popupVC = self.presentPopUpVC("MoneyAddedSuccessPopupVC", animated: true) as? MoneyAddedSuccessPopupVC {
            popupVC.delegate = self
            popupVC.selectedMoneyType = .BankAccount
        }
    }

}

extension AddBankDetailsVC : PopupDelegate {
    func isClickedButton() {
        self.navigationController?.popViewController(animated: false)
    }
}
