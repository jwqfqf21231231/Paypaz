//
//  NotificationsListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class NotificationsListVC : CustomViewController {
    
    private let dataSource = NotificationListDataModel()
    var notifications = [InvitesList]()
    var newNotifications = [InvitesList]()
    var currentPage = 1
    @IBOutlet weak var tableViewNotifications : UITableView! {
        didSet {
            self.tableViewNotifications.dataSource = self
            self.tableViewNotifications.delegate   = self
        }
    }
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource.deleteNotificationsDelegate = self
        Connection.svprogressHudShow(view: self)
        dataSource.pageNo = "0"
        dataSource.getNotifications()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 == self.notifications.count{
                Connection.svprogressHudShow(view: self)
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getNotifications()
            }
        }
    }
    //MARK:- ---- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ClearAll(_ sender:UIButton) {
        Connection.svprogressHudShow(view: self)
        dataSource.clearNotifications()
    }
}

