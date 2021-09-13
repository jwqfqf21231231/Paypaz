//
//  FavouritesEventsListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class FavouritesEventsListVC : CustomViewController {
    
    var favEvents = [MyEvent]()
    var newFavEvents = [MyEvent]()
    var currentPage = 1
    private let dataSource = FavouritesDataModel()
    let contactsDataSource = MyPostedEventDataModel()
    @IBOutlet weak var tableView_Events : UITableView! {
        didSet {
            tableView_Events.dataSource = self
            tableView_Events.delegate   = self
        }
    }
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        contactsDataSource.delegate3 = self
        getFavEvents()
    }
    private func getFavEvents()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getFavEvents()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 == self.favEvents.count{
                Connection.svprogressHudShow(view: self)
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getFavEvents()
            }
        }
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

