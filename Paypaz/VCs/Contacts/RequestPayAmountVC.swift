//
//  RequestPayAmountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 28/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

enum PaymentType {
    case local
    case global
}
class RequestPayAmountVC : CustomViewController {
    
    //MARK:- ---
    @IBOutlet weak var view_userInfo  : RoundView!
    @IBOutlet weak var userNameLabel  : UILabel!
    @IBOutlet weak var userNoLabel    : UILabel!
    @IBOutlet weak var userImage      : UIImageView!
    @IBOutlet weak var view_FromInfo  : UIView!
    @IBOutlet weak var view_Receiving : UIView!
    @IBOutlet weak var view_ConversionAmount : UIView!
    
    @IBOutlet weak var requestButton : UIButton!
    @IBOutlet weak var paythruCardButton : UIButton!
    @IBOutlet weak var paythruWalletButton : UIButton!
    
    private let payNowDataSource = PayNowDataModel()
    var paypazUser : Bool?
    var receiverID : String?
    var requestID : String?
    var userDetails : [String:String]?
    var selectedPaymentType : PaymentType?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        payNowDataSource.delegate = self
        //self.view_userInfo.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if paypazUser ?? false{
            paythruCardButton.isHidden = false
            paythruWalletButton.isHidden = false
        }
        else{
            paythruCardButton.isHidden = true
            paythruWalletButton.isHidden = true
        }
        if let type = self.selectedPaymentType {
            if type == .local {
                self.view_FromInfo.isHidden         = true
                self.view_Receiving.isHidden        = true
                self.view_ConversionAmount.isHidden = true
                
            } else {
                
                self.view_FromInfo.isHidden         = false
                self.view_Receiving.isHidden        = false
                self.view_ConversionAmount.isHidden = false
            }
        }
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestButton(_ sender:UIButton){
        if sender.tag == 0{
        }
        else if sender.tag == 1{
            if let vc = self.presentPopUpVC("AddMoneyPopupVC", animated: false) as? AddMoneyPopupVC{
                vc.successDelegate = self
                vc.payAmountToUser = true
            }
        }
        else{
            if let vc = self.pushVC("EnterPinVC") as? EnterPinVC{
                vc.delegate = self
            }
        }
        //        if let contacts = self.pushVC("ContactListVC") as? ContactListVC {
        //            let local = (self.selectedPaymentType == PaymentType.local)
        //            contacts.paymentOption = .Request
        //            contacts.isLocalContactSelected = local
        //            contacts.isRequestingMoney = true
        //            contacts.delegate = self
        //        }
        
    }
    
    @IBAction func paythruCardButton(_ sender:UIButton){
        /*if let contacts = self.pushVC("ContactListVC") as? ContactListVC {
         let local = (self.selectedPaymentType == PaymentType.local)
         contacts.paymentOption = .Pay
         contacts.isLocalContactSelected = local
         contacts.isRequestingMoney = false
         contacts.delegate = self
         }*/
        
        
    }
    
    
    
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
        }
    }
}
//MARK:- ---- Extension ----
extension RequestPayAmountVC : SendBackPinCodeDelegate{
    func sendBackPinCode(pin: String) {
        payNowDataSource.paymentMethod = "2"
        payNowDataSource.pincode = pin
        if self.requestID != nil{
            payNowDataSource.receiverID = receiverID ?? ""
            payNowDataSource.requestID = requestID ?? ""
        }
        else{
            payNowDataSource.phoneNumber = ""
        }
    }
}
extension RequestPayAmountVC : PayNowDelegate
{
    
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            
        }
        else
        {
            showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
extension RequestPayAmountVC : BuyEventThruCardDelegate{
    func buyEventThruCard(cvv: String, cardName: String, cardNumber: String, cardID: String) {
        print()
    }
}
extension RequestPayAmountVC : PopupDelegate {
    func isClickedButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let popup = self?.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                //  popup.delegate = self
                popup.selectedPopupType = .PayMoneyToContacts
            }
        }
    }
    
}

extension RequestPayAmountVC : ContactSelectedDelegate {
    
    func isSelectedContact(for request:Bool) {
        self.view_userInfo.alpha = 1.0
        if request {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                //  popup.delegate = self
                popup.selectedPopupType = .PaymentRequestSent
            }
        }
        //        }
        else{
            _ = self.pushVC("EnterPinVC")
        }
    }
}
