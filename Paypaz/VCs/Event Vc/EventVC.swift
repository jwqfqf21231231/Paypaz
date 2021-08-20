//
//  EventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventVC : CustomViewController {
    
    
    weak var delegate : PopupDelegate?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        NotificationCenter.default.addObserver(self, selector: #selector(goToCreatedEvent(_:)), name: NSNotification.Name("getEventID"), object: nil)
    }
    @objc func goToCreatedEvent(_ notification:Notification){
        if let dict = notification.userInfo as NSDictionary?{
            let eventID = dict["eventID"] as? String
            if let vc = self.pushVC("MyPostedEventDetailsVC") as? MyPostedEventDetailsVC{
                vc.eventID = eventID ?? ""

            }
        }
    }
    //MARK:- --- Action ----
    @IBAction func btn_HostEvent(_ sender:UIButton) {
       _ = self.pushToVC("HostEventVC")
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
