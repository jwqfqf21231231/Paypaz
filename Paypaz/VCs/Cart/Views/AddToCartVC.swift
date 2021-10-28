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
    var products = [MyProducts](){
        didSet{
            tableView_Height.constant = CGFloat.greatestFiniteMagnitude
            tableView_Products.reloadData()
            tableView_Products.layoutIfNeeded()
            tableView_Height.constant = self.tableView_Products.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    var cartItemProducts = [Product]()
    let dataSource = MyPostedEventDataModel()
    var eventPrice:Float = 0.0
    var productPrice:Float = 0.0
    var totalPrice:Float = 0.0
    var eventOriginalPrice : Float?
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
    @IBOutlet weak var hideProductsView : UIView!
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
    var updatedCartInfo : UpdatedCartInfo?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        if addToCart ?? false{
            if buyEvent ?? false{
                lbl_Title.text = "Buy Ticket"
                btn_AddToCart.isHidden = true
            }
            else{
                lbl_Title.text = "Add To Cart"
            }
            getEvent()
            getProducts()
        }
        else{
            btn_AddToCart.isHidden = true
            lbl_Title.text = "Buy Ticket"
            lbl_ViewAllProducts.text = "All Added Products"
            Connection.svprogressHudShow(view: self)
            addToCartDataSource.cartID = self.cartID
            addToCartDataSource.getCartDetails()
        }
        
    }
    
    func setDelegates(){
        addToCartDataSource.delegate = self
        dataSource.delegate = self
        dataSource.delegate2 = self
        addToCartDataSource.cartDetailsDelegate = self
        addToCartDataSource.cartCheckOutDelegate = self
    }
    
    func calculateTotalProductPrice(){
        if addToCart ?? false{
            productPrice = 0
            for i in 0..<products.count{
                productPrice += products[i].updatedProductPrice
            }
            self.lbl_ProductPrice.text = "$\(productPrice.clean)"
            calculateTotalPrice()
        }
        else{
            productPrice = 0
            for i in 0..<cartItemProducts.count{
                productPrice += cartItemProducts[i].updatedProductPrice ?? 0
            }
            self.lbl_ProductPrice.text = "$\(productPrice.clean)"
            calculateTotalPrice()
        }
    }
    func calculateTotalPrice(){
        self.totalPrice = (eventPrice+productPrice)
        lbl_TotalPrice.text = "$\(totalPrice.clean)"
        self.updatedCartInfo?.subTotal = "\(Double(self.totalPrice))"
        self.updatedCartInfo?.grandTotal = "\(Double(self.totalPrice))"
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
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Checkout(_ sender:UIButton) {
        let eventCount = ((self.lbl_EventCount.text ?? "") as NSString).integerValue
        if eventCount < 1{
            self.view.makeToast("Please add atleast one ticket for event")
        }
        else{
            if productsArray.count != 0 {
                let jsonData = try! JSONSerialization.data(withJSONObject:productsArray)
                let decoder = JSONDecoder()
                do {
                    let people = try decoder.decode([ProductList].self, from: jsonData)
                    updatedCartInfo?.products = people
                    self.updatedCartInfo?.productsPrice = "\(Double(productPrice))"
                    print(people)
                } catch {
                    print(error.localizedDescription)
                }
            }
            if let vc = self.pushVC("PayAmountVC") as? PayAmountVC{
                vc.cartInfo = self.updatedCartInfo
                vc.totalPrice = Float(self.totalPrice)
            }
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
        var count = Float(lbl_EventCount.text ?? "") ?? 0.0
        if sender.tag == 0{
            if count > 0{
                count = count-1
            }
        }
        else{
            count = count+1
        }
        lbl_EventCount.text = "\(Int(count))"
        eventPrice = (eventOriginalPrice ?? 0) * count
        lbl_EventPrice.text = "$\(eventPrice.clean)"
        self.updatedCartInfo?.eventQty = "\(Int(count))"
        self.updatedCartInfo?.eventPrice = "\(Double(eventPrice))"
        self.calculateTotalPrice()
    }
}
