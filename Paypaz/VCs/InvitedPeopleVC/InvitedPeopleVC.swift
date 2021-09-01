//
//  InvitedPeopleVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class InvitedPeopleVC  : CustomViewController {
    
    var contacts = [InvitedContacts](){
        didSet{
            let screenSize = UIScreen.main.bounds.size.height * 0.65
            let cellHeight = (UIScreen.main.bounds.size.width * 0.9 * 0.9 * 0.12) + 16
            let tblHeight  = CGFloat(self.contacts.count) * cellHeight
            if tblHeight > screenSize {
                self.tableViewHeight.constant = screenSize
            } else {
                self.tableViewHeight.constant = tblHeight
            }
            tableViewPeople.reloadData()
        }
    }
    var peopleInvited : Bool?
    var eventID = ""
    @IBOutlet weak var tableViewHeight : NSLayoutConstraint!
    @IBOutlet weak var tableViewPeople : UITableView! {
        didSet {
            self.tableViewPeople.dataSource = self
            self.tableViewPeople.delegate   = self
        }
    }
    private let dataSource = MyPostedEventDataModel()
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        dataSource.delegate3 = self
        if peopleInvited ?? false{
            getInvitees()
        }
    }
    func getInvitees()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.getContacts()
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
        let cellHeight = (UIScreen.main.bounds.size.width * 0.9 * 0.9 * 0.12) + 16
        let tblHeight  = CGFloat(self.contacts.count) * cellHeight
        if tblHeight > screenSize {
            self.tableViewHeight.constant = screenSize
        } else {
            self.tableViewHeight.constant = tblHeight
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
extension InvitedPeopleVC : MyPostedContactsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedContactsModel)
    {
        print("MyPostedContactsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.contacts = data.data ?? []
//            self.tableViewPeople.reloadData()
        }
        else
        {
            print(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError3(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
        }
    }
}
