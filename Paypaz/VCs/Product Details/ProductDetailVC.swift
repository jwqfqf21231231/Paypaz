//
//  ProductDetailVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 04/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailVC : CustomViewController {
    //productID will come from previousVC .ie ViewAllProductsVC
    var productID = ""
    var eventName = ""
    var eventID = ""
    var product : MyProducts?
    private let dataSource = ProductDetailsDataModel()
    @IBOutlet weak var img_ProductPic : UIImageView!
    @IBOutlet weak var lbl_ProductName : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    @IBOutlet weak var lbl_ProductQuantity : UILabel!
    @IBOutlet weak var lbl_Description : UILabel!
    @IBOutlet weak var lbl_EventName : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        getProductDetails()
    }
    
    private func getProductDetails()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.productID = self.productID
        dataSource.getProductDetails()
    }
    
    //MARK:- --- Action ---
    @IBAction func btn_back (_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Share(_ sender:UIButton){
        postshareLink(profile_URL: "The text that i want to share")
    }
}
extension ProductDetailVC : ProductDetailsDataModelDelegate
{
    func didRecieveDataUpdate2(data: ProductDetailsModel)
    {
        print("ProductDetailsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.eventID = data.data?.eventID ?? ""
            self.productID = data.data?.id ?? ""
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = data.data?.image ?? ""
            self.img_ProductPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
            self.lbl_ProductName.text = data.data?.name
            self.lbl_Description.text = data.data?.dataDescription
            self.lbl_EventName.text = self.eventName
            if data.data?.isPaid ?? "" == "0"{
                self.lbl_ProductPrice.text = "Price : Free"
            }
            else{
                self.lbl_ProductPrice.text = "Price : $\(Float(data.data?.price ?? "")?.clean ?? "")"
            }
            self.lbl_ProductQuantity.text = data.data?.quantity ?? ""
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            }
        }
    }
    
    func didFailDataUpdateWithError2(error: Error)
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
