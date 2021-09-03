//
//  ViewAllProductsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ViewAllProductsVC : CustomViewController {
  
    var eventName = ""
    var eventID = ""
    var products = [MyProducts]()
    var newProducts = [MyProducts]()
    var currentPage = 1
    
    private let dataSource = MyPostedEventDataModel()
    let dataSource1 = ProductDetailsDataModel()
    weak var delegate : PopupDelegate?
    
    @IBOutlet weak var lbl_EventName : UILabel!
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
    }
   
    func getAllProducts()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = eventID
        dataSource.pageNo = "0"
        self.currentPage = 1
        dataSource.getProducts()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 == self.products.count{
                Connection.svprogressHudShow(view: self)
                dataSource.eventID = eventID
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getProducts()
            }
        }
    }
    
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
}
