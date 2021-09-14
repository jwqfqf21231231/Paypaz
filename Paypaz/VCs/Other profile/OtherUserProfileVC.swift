//
//  OtherUserProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 20/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class OtherUserProfileVC : CustomViewController {
    var userID : String?
    var events = [MyEvent]()
    private let userProfileDataSource = LogInDataModel()
    private let eventDataSource = MyEventsListDataModel()
    @IBOutlet weak var img_OtherUserPic : UIImageView!
    @IBOutlet weak var lbl_UserName : UILabel!
    @IBOutlet weak var lbl_DOB : UILabel!
    @IBOutlet weak var lbl_Country : UILabel!
    @IBOutlet weak var tableView_Events : UITableView! {
        didSet {
            tableView_Events.dataSource = self
            tableView_Events.delegate   = self
        }
    }
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile()
        getFirst10Events()
    }
    private func getFirst10Events(){
        Connection.svprogressHudShow(view: self)
        eventDataSource.delegate = self
        eventDataSource.userID = self.userID ?? ""
        eventDataSource.pageNo = "0"
        eventDataSource.getOtherUserEvents()
    }
    private func getUserProfile(){
        userProfileDataSource.delegate = self
        userProfileDataSource.userID = self.userID ?? ""
        Connection.svprogressHudShow(view: self)
        userProfileDataSource.getUserProfile()
    }
    
    //MARK:- ---- Action ----
    @IBAction func btn_back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}
