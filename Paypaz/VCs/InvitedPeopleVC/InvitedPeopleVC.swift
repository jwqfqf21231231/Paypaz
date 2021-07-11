//
//  InvitedPeopleVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class InvitedPeopleVC  : CustomViewController {
   
   
   @IBOutlet weak var tableViewHeight : NSLayoutConstraint!
   @IBOutlet weak var tableViewPeople : UITableView! {
       didSet {
           self.tableViewPeople.dataSource = self
           self.tableViewPeople.delegate   = self
       }
   }
   
   //MARK:- ---- View Life Cycle ----
   override func viewDidLoad() {
       super.viewDidLoad()
       
    self.view.backgroundColor = UIColor.clear
   }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
   override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
    
    let screenSize = UIScreen.main.bounds.size.height * 0.65
    let tblHeight  = self.tableViewPeople.contentSize.height
    if tblHeight > screenSize {
        self.tableViewHeight.constant = screenSize
    } else {
        self.tableViewHeight.constant = self.tableViewPeople.contentSize.height
    }
       
   }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
   //MARK:- ---- Action ----
   @IBAction func btn_SeeMore(_ sender:UIButton) {
       
   }
}
