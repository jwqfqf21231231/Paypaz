//
//  WelcomeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class WelcomeVC : CustomViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  //MARK:- --- Action ----
    @IBAction func btn_getStarted(_ sender:UIButton) {
        _ = self.pushToVC("LoginVC")
    }
}
