//
//  ViewAllProductsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ViewAllProductsVC : CustomViewController {
    //Here i will be using MyPostedProductModel and MyPostedProductDataModel
    //The value for eventID will come from previousVC i.e MyPostedEventDetailsVC
    var eventID = ""
    var products = [MyProducts]()
    private let dataSource = MyPostedEventDataModel()
    weak var delegate : PopupDelegate?
    @IBOutlet weak var tableView_Products : UITableView! {
        didSet {
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate2 = self
        getAllProducts()
        // Do any additional setup after loading the view.
    }
    func getAllProducts()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = eventID
        dataSource.getProducts()
    }
    
     // MARK: - --- Action ----
       @IBAction func btn_back(_ sender:UIButton) {
          self.navigationController?.popViewController(animated: true)
       }

}
