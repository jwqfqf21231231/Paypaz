//
//  MyCartVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyCartVC : CustomViewController {
    
    var eventID : String?
    var eventDetails : MyEvent?
    var products = [MyProducts]()
    let dataSource = MyPostedEventDataModel()
    var eventPrice = 0
    var productPrice = 0
    var eventOriginalPrice : Int?
    var productsPricesArray = [Int]()
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var lbl_EventName : UILabel!
    @IBOutlet weak var lbl_EventDate : UILabel!
    @IBOutlet weak var lbl_Address : UILabel!
    @IBOutlet weak var lbl_Price : UILabel!
    @IBOutlet weak var lbl_EventPrice : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    @IBOutlet weak var lbl_TotalPrice : UILabel!
    @IBOutlet weak var lbl_EventCount : UILabel!
    @IBOutlet weak var tableView_Products : UITableView! {
        didSet {
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    @IBOutlet weak var tableView_Height   : NSLayoutConstraint!
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource.delegate2 = self
        getEvent()
        getProducts()
    }
    func calculateTotalProductPrice(){
        productPrice = 0
        for i in 0..<products.count{
            productPrice += products[i].updatedProductPrice
        }
        self.lbl_ProductPrice.text = "$\(productPrice)"
        calculateTotalPrice()
    }
    func calculateTotalPrice(){
        lbl_TotalPrice.text = "$\(eventPrice+productPrice)"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView_Height.constant = CGFloat(self.products.count * 135)
    }
    
    func getEvent()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID ?? ""
        dataSource.getEvent()
    }
    
    func getProducts()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID ?? ""
        dataSource.getProducts()
    }
    
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Checkout(_ sender:UIButton) {
        _ = self.pushVC("PayAmountVC")
    }
    @IBAction func btn_IncreaseEvent(_ sender:UIButton){
        var count = (lbl_EventCount.text! as NSString).integerValue
        if sender.tag == 0{
            if count > 0{
                count = count-1
            }
        }
        else{
            count = count+1
        }
        lbl_EventCount.text = "\(count)"
        eventPrice = (eventOriginalPrice ?? 0) * count
        lbl_EventPrice.text = "$\(eventPrice)"
        self.calculateTotalPrice()
    }
}
