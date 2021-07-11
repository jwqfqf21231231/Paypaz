//
//  MyTicketsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyTicketsVC : CustomViewController {
    
    @IBOutlet weak var tableView_Tickets : UITableView! {
        didSet {
            tableView_Tickets.dataSource = self
            tableView_Tickets.delegate   = self
        }
    }
    
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

     // MARK: - --- Action ----
       @IBAction func btn_back(_ sender:UIButton) {
          self.navigationController?.popViewController(animated: true)
       }

}
