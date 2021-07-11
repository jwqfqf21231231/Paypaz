//
//  EventReportsHistoryVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 04/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventReportsHistoryVC : CustomViewController {
    
    @IBOutlet weak var tableView_Contacts : UITableView! {
        didSet {
            tableView_Contacts.dataSource = self
            tableView_Contacts.delegate   = self
        }
    }
   
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

