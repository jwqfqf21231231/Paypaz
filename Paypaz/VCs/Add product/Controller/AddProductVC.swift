//
//  AddProductVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
protocol AddProductDelegate : class {
    func isAddedProduct()
}
typealias DataCallback = ([String:Any]) -> Void
class AddProductVC : CustomViewController {
    var callback : DataCallback?
    //var createdProductData : ((_ productImage:UIImage,_ price:String,_ name:String,_ description:String) -> Void)?
    var isEdit : Bool?
    var eventID = ""
    var productID = ""
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    weak var delegate : AddProductDelegate?
    private let dataSource = AddProductDataModel()
    private let dataSource1 = ProductDetailsDataModel()
    @IBOutlet weak var view_DashedView : UIView!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var img_ProductPic : UIImageView!
    @IBOutlet weak var txt_ProductName : RoundTextField!
    @IBOutlet weak var txt_ProductPrice : RoundTextField!
    @IBOutlet weak var txt_ProductQuantity : RoundTextField!
    @IBOutlet weak var txt_Description : RoundTextView!
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource1.delegate = self
        hideKeyboardWhenTappedArround()
        setTitle()
        setDelegates()
        self.txt_Description.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        self.view.backgroundColor = UIColor.clear
    }
    private func setTitle()
    {
        if isEdit ?? false
        {
            lbl_Title.text = "Edit Product"
            Connection.svprogressHudShow(view: self)
            dataSource1.productID = self.productID
            dataSource1.getProductDetails()
        }
        else
        {
            lbl_Title.text = "Add Product"
        }
    }
    private func setDelegates()
    {
        self.txt_ProductName.delegate = self
        self.txt_ProductPrice.delegate = self
        self.txt_ProductQuantity.delegate = self
        self.txt_Description.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    
    
    //MARK:- --- Action ----
    @IBAction func btn_AddPic(_ sender:UIButton)
    {
        ImagePickerController.init().pickImage(self, isCamraFront:fontCamera) { (img) in
            self.img_ProductPic.image = img
            self.view_DashedView.isHidden = true
            self.pickedImage = img
            self.images["identity_img"] = img
        }
    }
    @IBAction func btn_Done(_ sender:UIButton) {
        if(img_ProductPic.image == nil)
        {
            self.view.makeToast("Please give Product Image")
        }
        else if(txt_ProductName.text?.trim().count == 0)
        {
            self.view.makeToast("Please Enter Product Name")
        }
        else if(txt_ProductPrice.text?.trim().count == 0)
        {
            self.view.makeToast("Please Specify Product Price")
        }
        else if(txt_ProductQuantity.text?.trim().count == 0)
        {
            self.view.makeToast("Please Specify Product Quantity")
        }
        else if(txt_Description.text.trim().count == 0)
        {
            self.view.makeToast("Please give some Description about your Product")
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.productPic = img_ProductPic.image
            dataSource.productName = txt_ProductName.text ?? ""
            dataSource.productPrice = txt_ProductPrice.text ?? ""
            dataSource.productQuantity = txt_ProductQuantity.text ?? ""
            dataSource.productDescription = txt_Description.text ?? ""
            dataSource.eventID = eventID
            if isEdit ?? false
            {
                dataSource.productID = self.productID
                dataSource.editProduct()
            }
            else
            {
                dataSource.addProduct()
            }
            //        self.dismiss(animated: true) { [weak self] in
            //            self?.delegate?.isAddedProduct()
            //        }
        }
        
    }
}
extension AddProductVC : ProductDetailsDataModelDelegate
{
    func didRecieveDataUpdate2(data: ProductDetailsModel)
    {
        print("ProductInfoModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = data.data?.image ?? ""
            self.img_ProductPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
            self.view_DashedView.isHidden = true
            self.txt_ProductName.text = data.data?.name
            self.txt_ProductPrice.text = data.data?.price
            self.txt_Description.text = data.data?.dataDescription
//            guard let callback = self.callback else { return }
//            callback(["productImage":img_ProductPic.image!,"productName":txt_ProductName.text!,"productPrice":txt_ProductPrice.text!,"productDescription":txt_Description.text!,"productID":data.data?.id ?? ""])
//            self.dismiss(animated: true)
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
extension AddProductVC : AddProductDataModelDelegate
{
    func didRecieveDataUpdate(data: AddProductModel)
    {
        print("AddProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            guard let callback = self.callback else { return }
            callback(["productImage":img_ProductPic.image!,"productName":txt_ProductName.text!,"productPrice":txt_ProductPrice.text!,"productDescription":txt_Description.text!,"productID":data.data?.id ?? ""])
            self.dismiss(animated: true)
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
extension AddProductVC : EditProductDataModelDelegate
{
    func didRecieveDataUpdate3(data: AddProductModel)
    {
        print("EditProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.navigationController?.popViewController(animated: false)
            self.delegate?.isAddedProduct()
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
