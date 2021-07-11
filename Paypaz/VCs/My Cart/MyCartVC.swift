//
//  MyCartVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyCartVC : CustomViewController {
    
    @IBOutlet weak var tableView_Products : UITableView! {
        didSet {
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    @IBOutlet weak var tableView_Height   : NSLayoutConstraint!
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
       self.tableView_Height.constant = self.tableView_Products.contentSize.height
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Checkout(_ sender:UIButton) {
        _ = self.pushToVC("PayAmountVC")
    }
    
}
