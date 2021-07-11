//
//  SideDrawerBaseVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import LGSideMenuController

class SideDrawerBaseVC : LGSideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sideMenuController?.leftViewPresentationStyle = .scaleFromBig
    }
    

    
    

}
