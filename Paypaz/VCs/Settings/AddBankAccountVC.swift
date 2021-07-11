//
//  AddBankAccountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class AddBankAccountVC : CustomViewController {

   
   
   // MARK:- ---- View Life Cycle ----
   override func viewDidLoad() {
       super.viewDidLoad()

        
   }
   

  // MARK: - --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
       
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if let popup = self.presentPopUpVC("BankSavedSuccessPopupVC", animated: false) as? BankSavedSuccessPopupVC {
            popup.delegate = self
        }
    }
}
//MARK:-
extension AddBankAccountVC : PopupDelegate {
    
    func isClickedButton() {
        self.navigationController?.popViewController(animated: false)
    }
}
