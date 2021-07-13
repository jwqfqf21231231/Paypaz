//
//  AddProductVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
protocol AddProductDelegate : class {
    func isAddedProduct()
}
typealias DataCallback = ([String:Any]) -> Void
class AddProductVC : CustomViewController {
    var callback : DataCallback?
    //var createdProductData : ((_ productImage:UIImage,_ price:String,_ name:String,_ description:String) -> Void)?
    var isEdit : Bool?
    var productID = ""
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    weak var delegate : AddProductDelegate?
    private let dataSource = AddProductDataModel()
    
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var img_ProductPic : UIImageView!
    @IBOutlet weak var txt_ProductName : RoundTextField!
    @IBOutlet weak var txt_ProductPrice : RoundTextField!
    @IBOutlet weak var txt_Description : RoundTextView!
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        if isEdit ?? false
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
            dataSource.productID = self.productID
            dataSource.editProduct()
        }
        else
        {
            
        }
        setDelegates()
        dataSource.delegate = self
        self.txt_Description.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        self.view.backgroundColor = UIColor.clear
    }
    private func setTitle()
    {
        if isEdit ?? false
        {
            lbl_Title.text = "Edit Product"
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
                    self.pickedImage = img
                    self.images["identity_img"] = img
                }
    }
    @IBAction func btn_Done(_ sender:UIButton) {
        if(img_ProductPic.image == nil)
        {
            showAlert(withMsg: "Please give Product Image", withOKbtn: true)
        }
        else if(txt_ProductName.text == "")
        {
            showAlert(withMsg: "Please Enter Product Name", withOKbtn: true)
        }
        else if(txt_ProductPrice.text == "")
        {
            showAlert(withMsg: "Please Specify Product Price" , withOKbtn: true)
        }
        else if(txt_Description.text == "")
        {
            showAlert(withMsg: "Please give some Description about your Product", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
            dataSource.productPic = pickedImage
            dataSource.productName = txt_ProductName.text ?? ""
            dataSource.productPrice = txt_ProductPrice.text ?? ""
            dataSource.productDescription = txt_Description.text ?? ""
            dataSource.addProduct()
    //        self.dismiss(animated: true) { [weak self] in
    //            self?.delegate?.isAddedProduct()
    //        }
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
    func didRecieveDataUpdate2(data: AddProductModel)
    {
        print("EditProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.navigationController?.popViewController(animated: false)
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
