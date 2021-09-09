//
//  DeleteEventPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol DeleteProductDelegate : class {
    func deleteProductData(indexNo:Int)
}
protocol DeleteEventDelegate : class {
    func deleteEventData(eventID :String)
}
class DeleteEventPopupVC : CustomViewController {
    
    weak var updateEventDelegate : DeleteEventDelegate?
    weak var updateProductDelegate : DeleteProductDelegate?
    var eventID = ""
    var productID = ""
    var indexNo : Int?
    var deleteProduct : Bool?
    var type : String?
    private let dataSource = DeleteEventDataModel()
    private let deleteProductDataSource = ProductDetailsDataModel()
    @IBOutlet var lbl_Title : UILabel!
    @IBOutlet var lbl_Description : UILabel!
    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        deleteProductDataSource.delegate2 = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setTitle()
    }
    func setTitle(){
        if deleteProduct ?? false{
            lbl_Title.text = "Delete Product"
            lbl_Description.text = "Are you sure you want to delete this product"
        }
        else{
            lbl_Title.text = "Delete Event"
            lbl_Description.text = "Are you sure you want to delete this event"
        }
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Yes(_ sender:UIButton) {
        if deleteProduct ?? false{
            Connection.svprogressHudShow(view: self)
            deleteProductDataSource.eventID = self.eventID
            deleteProductDataSource.productID = self.productID
            deleteProductDataSource.type = self.type ?? ""
            deleteProductDataSource.deleteProduct()
        }
        else{
            Connection.svprogressHudShow(view: self)
            dataSource.eventID = self.eventID
            dataSource.deleteEvent()
        }
    }
    @IBAction func btn_No(_ sender:UIButton) {
        self.dismiss(animated: false)
    }
    
    
}
extension DeleteEventPopupVC : DeleteProductDataModelDelegate
{
    func didRecieveDataUpdate(data: SuccessModel)
    {
        print("DeleteProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.dismiss(animated: false) {[weak self] in
                self?.updateProductDelegate?.deleteProductData(indexNo: self?.indexNo ?? 0)
            }
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
extension DeleteEventPopupVC : DeleteEventDataModelDelegate
{
    func didRecieveDataUpdate(data: SignUpModel)
    {
        print("DeleteEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.dismiss(animated: false) {[weak self] in
                self?.updateEventDelegate?.deleteEventData(eventID: self?.eventID ?? "")
                //  self?.delegate?.isClickedButton()
            }
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
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

