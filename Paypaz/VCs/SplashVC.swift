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
            if UserDefaults.standard.getLoggedIn() == "1"
            {
                if UserDefaults.standard.value(forKey: "isVerify") as? String == "1" && UserDefaults.standard.value(forKey: "isPasscode") as? String == "1" && UserDefaults.standard.value(forKey: "isPin") as? String == "1" /*&& UserDefaults.standard.value(forKey: "isVerifyCard") as? String == "1"*/
                {
                    _ = self?.pushVC("PasscodeVC")
                }
                else
                {
                    if UserDefaults.standard.value(forKey: "isVerify") as? String != "1"
                    {
                        _ = self?.pushVC("OTPVerificationVC")
                    }
                    else if UserDefaults.standard.value(forKey: "isProfile") as? String != "1"
                    {
                        _ = self?.pushVC("CreateProfileVC")
                    }
                    else if UserDefaults.standard.value(forKey: "isPasscode") as? String != "1"
                    {
                        _ = self?.pushVC("CreatePasscodeVC")
                    }
                    else if UserDefaults.standard.value(forKey: "isPin") as? String != "1"
                    {
                        if let vc = self?.pushVC("CreatePinVC") as? CreatePinVC
                        {
                            vc.isCreatingPin = true
                        }
                    }
                    /*else if UserDefaults.standard.value(forKey: "isVerifyCard") as? String != "1"
                     {
                     if let vc = self?.pushVC("CreditDebitCardVC") as? CreditDebitCardVC
                     {
                     vc.fromPin = true
                     }
                     }*/
                }
            }
            else
            {
                self?.getLocation()
                _ = self?.pushVC("WelcomeVC")
            }
            
        }
    }
    // MARK:- Getting Current Location
    private func getLocation()
    {
        LocationManager.shared.getUserLocation { (lat, long) in
            if lat != nil && long != nil{
                DispatchQueue.main.async {
                    UserDefaults.standard.setLatitude(value: "\(lat ?? 0.0)")
                    UserDefaults.standard.setLongitude(value: "\(long ?? 0.0)")
                }
            }
        }
    }
}
