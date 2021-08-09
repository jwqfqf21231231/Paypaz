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
//        if UserDefaults.standard.isLoggedIn() == true
//        {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
//                        _ = self?.pushToVC("LoginVC", animated: false)
//                    }
//        }
//        else
//        {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
//                        _ = self?.pushToVC("WelcomeVC", animated: false)
//                    }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            if UserDefaults.standard.isLoggedIn() == true
            {
                if UserDefaults.standard.value(forKey: "isVerify") as? String == "1" && UserDefaults.standard.value(forKey: "isPasscode") as? String == "1" && UserDefaults.standard.value(forKey: "isPin") as? String == "1" && UserDefaults.standard.value(forKey: "isVerifyCard") as? String == "1"
                {
                    if UserDefaults.standard.isLoggedIn() == true
                    {
                        _ = self?.pushToVC("PasscodeVC")
                    }
                    else
                    {
                        _ = self?.pushToVC("WelcomeVC")
                    }
                    
                }else
                {

                    if UserDefaults.standard.value(forKey: "isVerify") as? String != "1"
                    {
                        _ = self?.pushToVC("OTPVerificationVC")
                    }
                    else if UserDefaults.standard.value(forKey: "isProfile") as? String != "1"
                    {
                        if let vc = self?.pushToVC("CreateProfileVC") as? CreateProfileVC
                        {
                            vc.isUpdate = "1"
                        }
                    }
                    else if UserDefaults.standard.value(forKey: "isPasscode") as? String != "1"
                    {
                        _ = self?.pushToVC("CreatePasscodeVC")
                    }
                    else if UserDefaults.standard.value(forKey: "isPin") as? String != "1"
                    {
                        if let vc = self?.pushToVC("CreatePinVC") as? CreatePinVC
                        {
                            vc.isCreatingPin = true
                        }
                    }
                    else if UserDefaults.standard.value(forKey: "isVerifyCard") as? String != "1"
                    {
                        if let vc = self?.pushToVC("CreditDebitCardVC") as? CreditDebitCardVC
                        {
                            vc.fromPin = true
                        }
                    }
                }
            }
            else
            {
                _ = self?.pushToVC("WelcomeVC")
            }
           
        }
    }
}

