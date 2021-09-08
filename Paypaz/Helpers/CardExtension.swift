//
//  CardExtension.swift
//  Paypaz
//
//  Created by mac on 23/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Network
import DropDown

class CardViewController : UIViewController {
    
    var didChangeNetworkConnection : ((Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.addNetworkCheckHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    func addNetworkCheckHandler() {
        //            if #available(iOS 12.0, *) {
        //                let appDel = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
        //                appDel.monitor.start(queue: .global())
        //                appDel.monitor.pathUpdateHandler = { [weak self] path in
        //
        //                  //  DispatchQueue.main.async {
        //                        if path.status == .satisfied {
        //                            appDel.isNetworkConnected = true
        //                            self?.didChangeNetworkConnection?(true)
        //                        } else {
        //                            appDel.isNetworkConnected = false
        //                            self?.didChangeNetworkConnection?(false)
        //                        }
        //                   // }
        //                }
        //            }
    }
}


