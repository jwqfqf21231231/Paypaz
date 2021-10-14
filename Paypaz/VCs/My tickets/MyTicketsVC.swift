//
//  MyTicketsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyTicketsVC : CustomViewController {
    
    @IBOutlet weak var myTicketsHeaderLabel : UILabel!
    @IBOutlet weak var noDataFoundView : UIView!
    @IBOutlet weak var tableView_Tickets : UITableView! {
        didSet {
            tableView_Tickets.dataSource = self
            tableView_Tickets.delegate   = self
        }
    }
    private let userTicketsDataSource = UserTicketsDataModel()
    var tickets : [Tickets]?{
        didSet{
            tableView_Tickets.reloadData()
        }
    }
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        userTicketsDataSource.userTicketsDelegate = self
        userTicketsDataSource.pageNo = "0"
        Connection.svprogressHudShow(view: self)
        userTicketsDataSource.getUserTickets()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
