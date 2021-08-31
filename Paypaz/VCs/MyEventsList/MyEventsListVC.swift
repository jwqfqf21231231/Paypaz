//
//  MyEventsListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyEventsListVC : CustomViewController {
    
    var events = [MyEvent]()
    var newEventItems = [MyEvent]()
    var currentPage = 1
    let dataSource = MyEventsListDataModel()
    @IBOutlet weak var tableView_Events : UITableView! {
        didSet {
            tableView_Events.dataSource = self
            tableView_Events.delegate   = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Connection.svprogressHudShow(view: self)
        dataSource.delegate = self
        dataSource.pageNo = "0"
        dataSource.getMyEvents()
    }
    func postshareLink(profile_URL:String){
            let objectsToShare = [profile_URL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = self.view
            
            activityVC.completionWithItemsHandler = { activity, success, items, error in
                if success{
                    print("Successfully Send link")
                    self.dismiss(animated: true, completion: nil)
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 == self.events.count{
                Connection.svprogressHudShow(view: self)
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getMyEvents()
            }
        }
    }
    // MARK: - ---- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

