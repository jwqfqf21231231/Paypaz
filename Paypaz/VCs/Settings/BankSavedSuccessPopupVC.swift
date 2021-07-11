//
//  BankSavedSuccessPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class BankSavedSuccessPopupVC : CustomViewController {

    weak var delegate : PopupDelegate?
    
    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    

   // MARK: - --- Action ----
    @IBAction func btn_Continue(_ sender:UIButton) {
        self.dismiss(animated: false) { [weak self] in
             self?.delegate?.isClickedButton()
        }
       
    }
    
   
    
}
