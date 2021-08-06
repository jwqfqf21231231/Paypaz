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
    //  MARK:- Getting Current Location
    private func getLocation()
    {
        let instance = LocationManager.shared
        instance.getUserLocation { (lat, long) in
            if lat != nil && long != nil{
                UserDefaults.standard.setLatitude(value: "\(lat ?? 0.0)")
                UserDefaults.standard.setLongitude(value: "\(long ?? 0.0)")
//                self.location  = CLLocation.init(latitude: lat ?? 0.0, longitude: long ?? 0.0)
//                UserDefaults.standard.synchronize()
//                                if AppSettings.hasLogInApp{
//                                    CurrentLocationAPI()
//                                }
            }
            
        }
    }

  //MARK:- --- Action ----
    @IBAction func btn_getStarted(_ sender:UIButton) {
        getLocation()
        _ = self.pushToVC("LoginVC")
    }
}
