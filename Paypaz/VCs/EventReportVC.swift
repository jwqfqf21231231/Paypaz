//
//  EventReportVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventReportVC : CustomViewController {
    
    
    @IBOutlet weak var view_TotalSale   : PlainCircularProgressBar!
    @IBOutlet weak var view_TicketSold  : PlainCircularProgressBar!
    @IBOutlet weak var view_EventSold   : PlainCircularProgressBar!
    @IBOutlet weak var view_ProductSold : PlainCircularProgressBar!
       
       
       //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view_TotalSale.progress   = 0.7
        self.view_TicketSold.progress  = 0.5
        self.view_EventSold.progress   = 0.6
        self.view_ProductSold.progress = 0.5
    }

   // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
