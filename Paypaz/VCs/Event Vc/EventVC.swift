//
//  EventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventVC : CustomViewController {
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK:- --- Action ----
    @IBAction func btn_HostEvent(_ sender:UIButton) {
        if let eventVC = self.pushToVC("HostEventVC") as? HostEventVC {
            eventVC.delegate = self
        }
    }
    @IBAction func btn_BuyEvent(_ sender:UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseEventTypeVC") as! ChooseEventTypeVC
        vc.doBuyEvent = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:-
extension EventVC : PopupDelegate {

    func isClickedButton() {
        _ = self.pushToVC("MyPostedEventDetailsVC")
        
    }
}
