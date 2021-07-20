//
//  MyEventsListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyEventsListVC : CustomViewController {
    
    var events = [Event]()
    let dataSource = MyEventsListDataModel()
    @IBOutlet weak var tableView_Events : UITableView! {
        didSet {
            tableView_Events.dataSource = self
            tableView_Events.delegate   = self
        }
    }
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.delegate = self
        dataSource.getMyEvents()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        print("View will Appear Executed")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        print("View did Appear Executed")
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
//        for vc in self.navigationController?.viewControllers ?? [] {
//            if let home = vc as? HomeVC {
//                self.navigationController?.popToViewController(home, animated: true)
//                break
//            }
//        }
    }
}

