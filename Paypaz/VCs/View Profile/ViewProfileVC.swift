//
//  ViewProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 26/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

class ViewProfileVC : CustomViewController {
    //Here i am using UserDetailsDataModel. You can find it in SideDrawer
    private let dataSource = UserDetailsDataModel()
    let eventDataSource = MyEventsListDataModel()
    var events = [MyEvent]()
    @IBOutlet weak var img_ProfilePic : UIImageView!
    @IBOutlet weak var lbl_ProfileName : UILabel!
    @IBOutlet weak var lbl_Address : UILabel!
    @IBOutlet weak var lbl_DOB : UILabel!
    @IBOutlet weak var lbl_PhoneNo : UILabel!
    //MARK:- ----
    @IBOutlet weak var tableViewEvents : UITableView! {
        didSet {
            self.tableViewEvents.dataSource = self
            self.tableViewEvents.delegate   = self
        }
    }
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.getUserDetails()
        self.getFirst10Events()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getUserDetails()
        self.getFirst10Events()
    }
    private func getFirst10Events(){
        Connection.svprogressHudShow(view: self)
        eventDataSource.delegate = self
        eventDataSource.pageNo = "0"
        eventDataSource.getMyEvents()
    }
    private func getUserDetails()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getUserDetails()
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ViewQR(_ sender:UIButton) {
        if let vc = self.pushVC("ScanQRCodeVC") as? ScanQRCodeVC{
            vc.userName = lbl_ProfileName.text ?? ""
            vc.userImage = img_ProfilePic.image ?? UIImage(named: "place_holder")
        }
        
    }
    @IBAction func btn_Edit(_ sender:UIButton) {
        _ = self.pushVC("EditProfileVC",animated: false)
    }
    @IBAction func btn_ViewAll(_ sender:UIButton){
        _ = self.pushVC("MyEventsListVC") 
    }
}
