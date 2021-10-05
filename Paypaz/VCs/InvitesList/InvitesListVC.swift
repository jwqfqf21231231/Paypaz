//
//  InvitesListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class InvitesListVC : CustomViewController {
    
    var invitesList = [InvitesList]()
    var newInvitesList = [InvitesList]()
    var currentPage = 1
     let dataSource = InvitesListDataModel()
    @IBOutlet weak var tableView_Invites : UITableView! {
        didSet {
            tableView_Invites.dataSource = self
            tableView_Invites.delegate   = self
        }
    }
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        Connection.svprogressHudShow(view: self)
        dataSource.getInvitees()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 >= self.invitesList.count{
                Connection.svprogressHudShow(view: self)
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getInvitees()
            }
        }
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

