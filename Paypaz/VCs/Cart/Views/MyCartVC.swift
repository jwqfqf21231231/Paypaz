//
//  MyCartVC.swift
//  Paypaz
//
//  Created by MAC on 23/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyCartVC: UIViewController {

    open var products = [Product]()
    var Items = [CartInfo]()
    private let dataSource = AddToCartDataModel()
    @IBOutlet weak var tableView_Items : UITableView! {
        didSet {
            tableView_Items.dataSource = self
            tableView_Items.delegate   = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.cartItemsDelegate = self
        Connection.svprogressHudShow(view: self)
        dataSource.getCartItems()
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
        //self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btn_AddToCart(_ sender:UIButton){
    }
}
