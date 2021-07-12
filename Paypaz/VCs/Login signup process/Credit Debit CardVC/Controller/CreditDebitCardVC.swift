//
//  CreditDebitCardVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CreditDebitCardVC : CustomViewController {

    var isAddingNewCard : Bool?
    
    @IBOutlet weak var btn_Skip : RoundButton!
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAddingNewCard ?? false {
            self.btn_Skip.alpha = 0.0
        }
    }

   // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_VerifyCard(_ sender:UIButton) {
        if isAddingNewCard ?? false {
           self.navigationController?.popViewController(animated: true)
        } else {
            _ = self.pushToVC("SideDrawerBaseVC")
        }
    }
    
    @IBAction func btn_Skip(_ sender:UIButton) {
        _ = self.pushToVC("SideDrawerBaseVC")
    }
    
}
