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
    var eventID = ""
    private let dataSource = ProductDetailsDataModel()
    private let dataSource2 = MyPostedEventDataModel()
    weak var delegate : PopupDelegate?
    @IBOutlet weak var img_ProductPic : UIImageView!
    @IBOutlet weak var lbl_ProductName : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    @IBOutlet weak var lbl_ProductQuantity : UILabel!
    @IBOutlet weak var lbl_Description : UILabel!
    @IBOutlet weak var lbl_EventName : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate2 = self
        dataSource.delegate = self
        dataSource2.delegate = self
        getProductDetails()
        getEventName()
        // Do any additional setup after loading the view.
    }
    private func getProductDetails()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.productID = self.productID
        dataSource.getProductDetails()
    }
    private func getEventName()
    {
        Connection.svprogressHudShow(view: self)
        dataSource2.eventID = eventID
        dataSource2.getEvent()
    }
    //MARK:- --- Action ---
    @IBAction func btn_back (_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.isClickedButton()
    }
    
    @IBAction func btn_Edit(_ sender:UIButton)
    {
        if let vc = self.pushToVC("AddProductVC") as? AddProductVC
        {
            vc.isEdit = true
            vc.productID = self.productID
            vc.delegate = self
        }
    }
    @IBAction func btn_Delete(_ sender:UIButton)
    {
        Connection.svprogressHudShow(view: self)
        dataSource.productID = self.productID
        dataSource.eventID = self.eventID
        dataSource.type = "1"
        dataSource.deleteProduct()
    }
}
extension ProductDetailVC : AddProductDelegate
{
    func isAddedProduct() {
        Connection.svprogressHudShow(view: self)
        dataSource.getProductDetails()
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
            self.lbl_ProductPrice.text = "Price:\(data.data?.price ?? "")"
            self.lbl_ProductQuantity.text = data.data?.quantity
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
extension ProductDetailVC : MyPostedEventDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedEventModel)
    {
        print("MyPostedEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.lbl_EventName.text = data.data?.name
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
extension ProductDetailVC : DeleteProductDataModelDelegate
{
    func didRecieveDataUpdate(data: SuccessModel)
    {
        print("DeleteProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.navigationController?.popViewController(animated: false)
            self.delegate?.isClickedButton()
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError3(error: Error)
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
