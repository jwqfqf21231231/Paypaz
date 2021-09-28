//
//  MyCartVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol AddedSuccessfullyPopUp : class{
    func addedToCart()
}
class AddToCartVC : CustomViewController {
    
    var cartID = ""
    var addToCart : Bool?
    var buyEvent : Bool?
    var eventID : String?
    var eventDetails : MyEvent?
    var products = [MyProducts]()
    var cartItemProducts = [Product]()
    let dataSource = MyPostedEventDataModel()
    var eventPrice = 0
    var productPrice = 0
    var totalPrice = 0
    var eventOriginalPrice : Int?
    var productDict = [String:String]()
    var productsArray = [[String:String]]()
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var lbl_EventName : UILabel!
    @IBOutlet weak var lbl_EventDate : UILabel!
    @IBOutlet weak var lbl_Address : UILabel!
    @IBOutlet weak var lbl_Price : UILabel!
    @IBOutlet weak var lbl_EventPrice : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    @IBOutlet weak var lbl_TotalPrice : UILabel!
    @IBOutlet weak var lbl_EventCount : UILabel!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var btn_AddToCart : UIButton!
    @IBOutlet weak var tableView_Height : NSLayoutConstraint!
    //@IBOutlet weak var view_Products : UIView!
    @IBOutlet weak var lbl_ViewAllProducts : UILabel!
    
    @IBOutlet weak var tableView_Products : UITableView! {
        didSet {
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    //@IBOutlet weak var tableView_Height   : NSLayoutConstraint!
    private let addToCartDataSource = AddToCartDataModel()
    weak var successDelegate:AddedSuccessfullyPopUp?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        if addToCart ?? false{
            if buyEvent ?? false{
                lbl_Title.text = "Buy Ticket"
                btn_AddToCart.isHidden = true
            }
            else{
                lbl_Title.text = "Add To Cart"
            }
            addToCartDataSource.delegate = self
            dataSource.delegate = self
            dataSource.delegate2 = self
            getEvent()
            getProducts()
        }
        else{
            btn_AddToCart.isHidden = true
            lbl_Title.text = "Buy Ticket"
            lbl_ViewAllProducts.text = "All Added Products"
            Connection.svprogressHudShow(view: self)
            addToCartDataSource.cartDetailsDelegate = self
            addToCartDataSource.cartID = self.cartID
            addToCartDataSource.getCartDetails()
        }
        
    }
    func calculateTotalProductPrice(){
        if addToCart ?? false{
            productPrice = 0
            for i in 0..<products.count{
                productPrice += products[i].updatedProductPrice
            }
            self.lbl_ProductPrice.text = "$\(productPrice)"
            calculateTotalPrice()
        }
        else{
            productPrice = 0
            for i in 0..<cartItemProducts.count{
                productPrice += cartItemProducts[i].updatedProductPrice ?? 0
            }
            self.lbl_ProductPrice.text = "$\(productPrice)"
            calculateTotalPrice()
        }
    }
    func calculateTotalPrice(){
        self.totalPrice = (eventPrice+productPrice)
        lbl_TotalPrice.text = "$\(eventPrice+productPrice)"
    }
    /* override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     
     self.tableView_Height.constant = CGFloat(self.products.count * 135)
     }*/
    
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
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Checkout(_ sender:UIButton) {
        let eventCount = ((self.lbl_EventCount.text ?? "") as NSString).integerValue
        if eventCount < 1{
            self.view.makeToast("Please add atleast one ticket for event")
        }
        else{
            _ = self.pushVC("PayAmountVC")
        }
    }
    @IBAction func btn_AddToCart(_ sender:UIButton){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        var currentDate = dateformatter.string(from: Date())
        currentDate = currentDate.localToUTC(incomingFormat: "yyyy-MM-dd HH:mm", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
        if ((lbl_EventCount.text! as NSString).integerValue) == 0{
            self.view.makeToast("Please add atleast one ticked for event")
        }
        else{
            Connection.svprogressHudShow(view: self)
            addToCartDataSource.eventID = self.eventID ?? ""
            addToCartDataSource.eventUserID = self.eventDetails?.userID ?? ""
            addToCartDataSource.eventQty = lbl_EventCount.text ?? ""
            addToCartDataSource.eventPrice = "\(Double(self.eventPrice))"
            addToCartDataSource.subTotal = "\(Double(self.totalPrice))"
            addToCartDataSource.discount = "0.0"
            addToCartDataSource.tax = "0.0"
            addToCartDataSource.grandTotal = "\(Double(self.totalPrice))"
            addToCartDataSource.addedDate = currentDate
            if products.count != 0{
                if productsArray.count != 0{
                    let jsonData = try! JSONSerialization.data(withJSONObject:productsArray)
                    let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                    print(jsonString!)
                    addToCartDataSource.products = jsonString ?? ""
                    addToCartDataSource.productsPrice = "\(Double(self.productPrice))"
                }
            }
            addToCartDataSource.addToCart()
        }
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
