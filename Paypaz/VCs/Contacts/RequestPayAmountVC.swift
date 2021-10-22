//
//  RequestPayAmountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 28/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
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
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var amountTxt : UITextField!
    
    @IBOutlet weak var requestView: UIView!{
        didSet{
            let tapGesture = CustomTapGestureRecognizer(target: self,
                                                        action: #selector(tapSelector(sender:)))
            tapGesture.viewIndex = requestView.tag
            requestView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var paythruCardView : UIView!{
        didSet{
            let tapGesture = CustomTapGestureRecognizer(target: self,
                                                        action: #selector(tapSelector(sender:)))
            tapGesture.viewIndex = paythruCardView.tag
            paythruCardView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var paythruWalletView : UIView!{
        didSet{
            let tapGesture = CustomTapGestureRecognizer(target: self,
                                                        action: #selector(tapSelector(sender:)))
            tapGesture.viewIndex = paythruWalletView.tag
            paythruWalletView.addGestureRecognizer(tapGesture)
        }
    }
    
    private let payNowDataSource = PayNowDataModel()
    private let payRequestDataSource = VerifyContactDataModel()
    var paypazUser : Bool?
    var receiverID : String?
    var requestID : String?
    var userDetails : [String:String]?
    var selectedPaymentType : PaymentType?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        payNowDataSource.delegate = self
        payRequestDataSource.requestPaymentDelegate = self
        //self.view_userInfo.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if paypazUser ?? false{
            self.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url =  APIList().getUrlString(url: .USERIMAGE)
            self.userImage.sd_setImage(with: URL(string: url+(userDetails?["userPic"] ?? "")), placeholderImage: UIImage(named: "place_holder"))
            self.userNameLabel.text = userDetails?["userName"]
            self.userNoLabel.text = "+\(userDetails?["phoneCode"] ?? "") \(userDetails?["phoneNumber"] ?? "")"
            paythruCardView.isHidden = false
            paythruWalletView.isHidden = false
        }
        else{
            userImage.image = UIImage(named: "place_holder")
            userNameLabel.text = userDetails?["userName"]
            userNoLabel.text = "+\(userDetails?["phoneCode"] ?? "") \(userDetails?["phoneNumber"] ?? "")"
            paythruCardView.isHidden = true
            paythruWalletView.isHidden = true
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
    @objc func tapSelector(sender: CustomTapGestureRecognizer) {
        if amountTxt.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter amount")
        }
//        else if descriptionTextView.isEmptyOrWhitespace(){
//            self.view.makeToast("Please enter description")
//        }
        else if (((amountTxt.text ?? "") as NSString).integerValue) < 20{
            self.view.makeToast("please send an amount of minimum 20$")
        }
        else{
            if sender.viewIndex == 0{
                if paypazUser ?? false{
                    payRequestDataSource.receiverID = receiverID ?? ""
                }
                else{
                    payRequestDataSource.receiverID = "0"
                    payRequestDataSource.name = userDetails?["userName"] ?? ""
                    payRequestDataSource.phoneNumber = userDetails?["phoneNumber"] ?? ""
                    payRequestDataSource.phoneCode = userDetails?["phoneCode"] ?? ""
                }
                payRequestDataSource.amount = amountTxt.text ?? ""
                payRequestDataSource.dataDescription = descriptionTextView.text ?? ""
                payRequestDataSource.requestPayment()
            }
            else if sender.viewIndex == 1{
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
        }
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestButton(_ sender:UIButton){
       
       
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
        payNowDataSource.dataDescription = descriptionTextView.text ?? ""
        payNowDataSource.amount = amountTxt.text ?? ""
        if self.requestID != nil{
            
            payNowDataSource.receiverID = receiverID ?? ""
            payNowDataSource.requestID = requestID ?? ""
        }
        else{
            payNowDataSource.requestID = "0"
            payNowDataSource.receiverID = "0"
            payNowDataSource.phoneNumber = userDetails?["phoneNumber"] ?? ""
            payNowDataSource.phoneCode = userDetails?["phoneCode"] ?? ""
            payNowDataSource.name = userDetails?["userName"] ?? ""
        }
        payNowDataSource.payNow()
    }
}

extension RequestPayAmountVC : BuyEventThruCardDelegate{
    func buyEventThruCard(cvv: String, cardName: String, cardNumber: String, cardID: String) {
        payNowDataSource.paymentMethod = "1"
        payNowDataSource.cardID = cardID
        payNowDataSource.cvv = cvv
        payNowDataSource.dataDescription = descriptionTextView.text ?? ""
        payNowDataSource.amount = amountTxt.text ?? ""
        if self.requestID != nil{
            payNowDataSource.receiverID = receiverID ?? ""
            payNowDataSource.requestID = requestID ?? ""
        }
        else{
            payNowDataSource.requestID = "0"
            payNowDataSource.receiverID = "0"
            payNowDataSource.phoneNumber = userDetails?["phoneNumber"] ?? ""
            payNowDataSource.phoneCode = userDetails?["phoneCode"] ?? ""
            payNowDataSource.name = userDetails?["userName"] ?? ""
        }
        payNowDataSource.payNow()
    }
}

extension RequestPayAmountVC : PayNowDelegate
{
    
    func didRecieveDataUpdate1(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let msg = ["Message": data.message ?? ""]
            for vc in self.navigationController?.viewControllers ?? [] {
                if let home = vc as? HomeVC {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPopUp"), object: nil, userInfo: msg)
                    self.navigationController?.popToViewController(home, animated: true)
                    break
                }
            }
        }
        else
        {
            showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError1(error: Error)
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

extension RequestPayAmountVC : PaymentRequestDelegate
{
    
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let msg = ["Message":data.message ?? ""]
            for vc in self.navigationController?.viewControllers ?? [] {
                if let home = vc as? HomeVC {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPopUp"), object: nil, userInfo: msg)
                    self.navigationController?.popToViewController(home, animated: true)
                    break
                }
            }
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
