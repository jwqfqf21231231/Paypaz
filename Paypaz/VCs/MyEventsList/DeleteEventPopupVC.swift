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
protocol PopUpScreenDelegate : class{
    func popUpScreen()
}
class DeleteEventPopupVC : CustomViewController {
    
    weak var updateEventDelegate : DeleteEventDelegate?
    weak var updateProductDelegate : DeleteProductDelegate?
    var selectedPopupType : PopupType?
    var popUpScreenDelegate : PopUpScreenDelegate?
    
    var eventID = ""
    var productID = ""
    var indexNo : Int?
    //var deleteProduct : Bool?
    var type : String?
    private let dataSource = DeleteEventDataModel()
    private let deleteProductDataSource = ProductDetailsDataModel()
    @IBOutlet var lbl_Title : UILabel!
    @IBOutlet var lbl_Description : UILabel!
    @IBOutlet weak var imgIcon     : UIImageView!
    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
    }
    func setDelegates(){
        dataSource.delegate = self
        deleteProductDataSource.delegate2 = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if let type = self.selectedPopupType {
            switch type {
            
            case .AddCard:
                imgIcon.image = UIImage(named: "Credit card-rafiki")
                lbl_Title.text = "No credit/debit cards are available?"
                lbl_Title.textColor = UIColor(named: "BlueColor")
                lbl_Description.text = "You have not added any credit/debit card for transactions.\n Do you want to add atleast one credit/debit card for transactions?"
            case .DeleteEvent:
                imgIcon.image = UIImage(named: "delete_event")
                lbl_Title.text = "Delete Event"
                lbl_Description.text = "Are you sure you want to delete this event"
            case .DeleteProduct:
                imgIcon.image = UIImage(named: "delete_event")
                lbl_Title.text = "Delete Product"
                lbl_Description.text = "Are you sure you want to delete this product"
            default:
                print("...")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Yes(_ sender:UIButton) {
        if let type = self.selectedPopupType {
            switch type {
            case .AddCard:
                self.dismiss(animated: false) {
                    self.popUpScreenDelegate?.popUpScreen()
                }
            case .DeleteEvent:
                Connection.svprogressHudShow(view: self)
                dataSource.eventID = self.eventID
                dataSource.deleteEvent()
            case .DeleteProduct :
                Connection.svprogressHudShow(view: self)
                deleteProductDataSource.eventID = self.eventID
                deleteProductDataSource.productID = self.productID
                deleteProductDataSource.type = self.type ?? ""
                deleteProductDataSource.deleteProduct()
            default:print("...")
            }
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

