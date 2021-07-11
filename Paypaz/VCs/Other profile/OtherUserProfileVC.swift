//
//  OtherUserProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 20/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class OtherUserProfileVC : CustomViewController {
    @IBOutlet weak var tableView_Products : UITableView! {
           didSet {
               tableView_Products.dataSource = self
               tableView_Products.delegate   = self
           }
       }
       
       //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   //MARK:- ---- Action ----
    @IBAction func btn_back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
