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
                        _ = self?.pushToVC("CreateProfileVC")
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
                self?.getLocation()
                _ = self?.pushToVC("WelcomeVC")
            }
            
        }
    }
    // MARK:- Getting Current Location
    private func getLocation()
    {
        let instance = LocationManager.shared
        instance.getUserLocation { (lat, long) in
            if lat != nil && long != nil{
                UserDefaults.standard.setLatitude(value: "\(lat ?? 0.0)")
                UserDefaults.standard.setLongitude(value: "\(long ?? 0.0)")
                
            }
            
        }
    }
}

