//
//  FavouritesEventsListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class FavouritesEventsListVC : CustomViewController {
    
    var favEvents = [Event]()
    private let dataSource = FavouritesDataModel()
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
        getFavEvents()
        // Do any additional setup after loading the view.
    }
    private func getFavEvents()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getFavEvents()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
      
    }

    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FavouritesEventsListVC : FavouritesListDataModelDelegate
{
    func didRecieveDataUpdate(data: MyEventsListModel)
    {
        print("FavEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.favEvents = data.data ?? []
            DispatchQueue.main.async {
                self.tableView_Events.reloadData()
            }
        }
        else
        {
            self.view.makeToast(data.message, duration: 3, position: .bottom)
           // self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
