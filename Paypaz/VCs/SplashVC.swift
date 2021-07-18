//
//  SplashVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class SplashVC : CustomViewController {

    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.isLoggedIn() == true
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                        _ = self?.pushToVC("LoginVC", animated: false)
                    }
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                        _ = self?.pushToVC("WelcomeVC", animated: false)
                    }
        }
        
    }
}

