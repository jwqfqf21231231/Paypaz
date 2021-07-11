//
//  NotificationsListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class NotificationsListVC : CustomViewController {
    
    //MARK:- ----
    @IBOutlet weak var tableViewNotifications : UITableView! {
        didSet {
            self.tableViewNotifications.dataSource = self
            self.tableViewNotifications.delegate   = self
        }
    }
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK:- ---- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ClearAll(_ sender:UIButton) {
        
    }
}
