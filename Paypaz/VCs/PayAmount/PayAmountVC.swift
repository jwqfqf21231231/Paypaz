//
//  PayAmountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
enum PayType {
    case paypaz
    case BankAcc
    case QRCode
    case ChangePayment
}
class PayAmountVC : CustomViewController {
    
    private var selectedPayType : PayType?
    
    @IBOutlet weak var stackView_Width : NSLayoutConstraint!
    @IBOutlet weak var btn_PayByPaypaz : RoundButton!
    @IBOutlet weak var btn_PayByQR     : RoundButton!
    @IBOutlet weak var btn_PayByBank   : RoundButton!
    @IBOutlet weak var btn_Submit      : RoundButton!
    @IBOutlet weak var btn_ChangePayment : UIButton!
    @IBOutlet weak var view_id_Description : UIView!
    @IBOutlet weak var view_QRCode       : UIView!
    @IBOutlet weak var lbl_id_accountNum : UILabel!
    @IBOutlet weak var img_bank_paypaz  : UIImageView!
    @IBOutlet weak var view_line1       : UIView!
    @IBOutlet weak var view_line2       : UIView!
    @IBOutlet weak var totalAmountLabel : UILabel!
    @IBOutlet weak var descriptionTextView : RoundTextView!
    @IBOutlet weak var hostImage : UIImageView!
    @IBOutlet weak var hostNameLabel : UILabel!
    
    /*@IBOutlet weak var btn_PayByPaypaz : RoundButton!
     @IBOutlet weak var btn_PayByQR     : RoundButton!
     @IBOutlet weak var btn_PayByBank   : RoundButton!*/
    private let userProfileDataSource = LogInDataModel()
    private let dataSource = PaymentDataModel()
    var userDetails = [String:String]()
    var totalPrice : Float?
    var cartInfo : UpdatedCartInfo?
    var cvv = ""
    var cardID = ""
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_ChangePayment.isHidden = true
        self.btn_Submit.isHidden  = true
        self.view_id_Description.isHidden = true
        self.view_line1.isHidden  = true
        self.view_line2.isHidden  = true
        self.view_QRCode.isHidden = true
        dataSource.delegate = self
        
        self.totalAmountLabel.text = "$\(totalPrice ?? 0)"
        getUserProfile()
    }
    private func updateUI(with type : PayType) {
        self.selectedPayType = type
        // self.stackView_Width.priority = UILayoutPriority(rawValue: 999)
        
        if type == .paypaz || type == .BankAcc {
            self.btn_ChangePayment.isHidden = false
            self.view_id_Description.isHidden = false
            self.view_line1.isHidden          = false
            self.view_line2.isHidden          = false
            self.btn_Submit.isHidden          = false
            self.btn_PayByPaypaz.isHidden     = true
            self.btn_PayByQR.isHidden         = true
            self.btn_PayByBank.isHidden       = true
            
            if type == .BankAcc {
                self.img_bank_paypaz.image  = UIImage(named: "surface")
                self.lbl_id_accountNum.text = "Account No : 03213543467567"
            }
            
        } else if type == .QRCode {
            self.btn_ChangePayment.isHidden = false
            self.btn_Submit.isHidden          = false
            self.btn_PayByPaypaz.isHidden     = true
            self.btn_PayByQR.isHidden         = true
            self.btn_PayByBank.isHidden       = true
            self.view_QRCode.isHidden         = false
        }
        else{
            self.btn_ChangePayment.isHidden = true
            self.btn_Submit.isHidden  = true
            self.view_id_Description.isHidden = true
            self.view_line1.isHidden  = true
            self.view_line2.isHidden  = true
            self.view_QRCode.isHidden = true
            self.btn_PayByPaypaz.isHidden = false
            self.btn_PayByQR.isHidden = false
            self.btn_PayByBank.isHidden = false
        }
    }
    
    
    private func getUserProfile(){
        userProfileDataSource.delegate = self
        userProfileDataSource.userID = self.cartInfo?.eventUserID ?? ""
        Connection.svprogressHudShow(view: self)
        userProfileDataSource.getUserProfile()
    }
    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
        }
    }
    @IBAction func btn_ChangePaymentMethod(_ sender:UIButton) {
        self.updateUI(with: .ChangePayment)
    }
    @IBAction func btn_PayByPaypaz(_ sender:UIButton) {
        
        self.updateUI(with: .paypaz)
    }
    @IBAction func btn_PayByQRCode(_ sender:UIButton) {
        self.updateUI(with: .QRCode)
    }
    @IBAction func btn_PayByBankAcc(_ sender:UIButton) {
        self.updateUI(with: .BankAcc)
        if UserDefaults.standard.value(forKey: "isVerifyCard") as! String != "1"{
            if let popupVC = self.presentPopUpVC("DeleteEventPopupVC", animated: false) as? DeleteEventPopupVC{
                popupVC.selectedPopupType = .AddCard
                popupVC.popUpScreenDelegate = self
            }
        }
        else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoneyPopupVC") as? AddMoneyPopupVC{
                vc.successDelegate = self
                vc.cartInfo = self.cartInfo
                vc.buyTicket = true
                vc.totalAmount = totalPrice
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if self.selectedPayType == .paypaz{
            if let vc = self.pushVC("EnterPinVC") as? EnterPinVC{
                vc.delegate = self
            }
        }
        else if self.selectedPayType == .QRCode{
            if let vc = self.pushVC("EnterPinVC") as? EnterPinVC{
                vc.delegate = self
            }
        }
        else{
            Connection.svprogressHudShow(view: self)
            dataSource.eventID = cartInfo?.eventID ?? ""
            dataSource.eventUserID = cartInfo?.eventUserID ?? ""
            dataSource.eventQty = cartInfo?.eventQty ?? ""
            dataSource.eventPrice = cartInfo?.eventPrice ?? ""
            dataSource.productsPrice = cartInfo?.productsPrice ?? ""
            dataSource.subTotal = cartInfo?.subTotal ?? ""
            dataSource.discount = cartInfo?.discount ?? ""
            dataSource.tax = cartInfo?.tax ?? ""
            dataSource.grandTotal = cartInfo?.grandTotal ?? ""
            dataSource.cartID = cartInfo?.cartID ?? ""
            dataSource.paymentType = cartInfo?.paymentType ?? ""
            dataSource.cvv = cvv
            dataSource.cardID = cardID
            if selectedPayType == .paypaz {
                dataSource.paymentMethod = "1"
            }
            else if selectedPayType == .QRCode{
                dataSource.paymentMethod = "2"
            }
            else{
                dataSource.paymentMethod = "3"
            }
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(cartInfo?.products)
            dataSource.products = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""//String(data: data, encoding: .utf8)!
            dataSource.requestPayment()
        }
        
        
//        if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
//            popup.delegate  = self
//            if let type = self.selectedPayType {
//                if type == .paypaz {
//                    popup.selectedPopupType = .PayMoneyToContacts
//                } else if type == .QRCode {
//                    popup.selectedPopupType = .PayMoneyToContacts
//                } else {
//                    popup.selectedPopupType = .EventAmountPaid
//                }
//            }
//
//        }
    }
    
    /*@IBAction func btn_PayByPaypaz(_ sender:UIButton) {
     if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
     vc.userDetails = self.userDetails
     vc.cartInfo = self.cartInfo
     vc.selectedPayType = .paypaz
     }
     }
     @IBAction func btn_PayByQRCode(_ sender:UIButton) {
     if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
     vc.userDetails = self.userDetails
     vc.cartInfo = self.cartInfo
     vc.selectedPayType = .QRCode
     }
     }
     @IBAction func btn_PayByBankAcc(_ sender:UIButton) {
     if UserDefaults.standard.value(forKey: "isVerifyCard") as! String != "1"{
     if let popupVC = self.presentPopUpVC("DeleteEventPopupVC", animated: false) as? DeleteEventPopupVC{
     popupVC.selectedPopupType = .AddCard
     popupVC.popUpScreenDelegate = self
     }
     }
     else{
     if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoneyPopupVC") as? AddMoneyPopupVC{
     vc.successDelegate = self
     vc.cartInfo = self.cartInfo
     vc.buyTicket = true
     vc.totalAmount = totalPrice
     vc.modalPresentationStyle = .overCurrentContext
     self.present(vc, animated: false, completion: nil)
     }
     }
     }*/
}
extension PayAmountVC : SendBackPinCodeDelegate{
    func sendBackPinCode(pin : String){
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = cartInfo?.eventID ?? ""
        dataSource.eventUserID = cartInfo?.eventUserID ?? ""
        dataSource.eventQty = cartInfo?.eventQty ?? ""
        dataSource.eventPrice = cartInfo?.eventPrice ?? ""
        dataSource.productsPrice = cartInfo?.productsPrice ?? ""
        dataSource.subTotal = cartInfo?.subTotal ?? ""
        dataSource.discount = cartInfo?.discount ?? ""
        dataSource.tax = cartInfo?.tax ?? ""
        dataSource.grandTotal = cartInfo?.grandTotal ?? ""
        dataSource.cartID = cartInfo?.cartID ?? ""
        dataSource.paymentType = cartInfo?.paymentType ?? ""
        dataSource.pincode = pin
        if selectedPayType == .paypaz {
            dataSource.paymentMethod = "1"
        }
        else if selectedPayType == .QRCode{
            dataSource.paymentMethod = "2"
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(cartInfo?.products)
        dataSource.products = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""//String(data: data, encoding: .utf8)!
        dataSource.requestPayment()
    }
}
extension PayAmountVC : PopupDelegate {
    func isClickedButton() {
        for vc in self.navigationController!.viewControllers as Array {
            let msg = ["Message":"Payment successful"]
            if vc.isKind(of:HomeVC.self) {
                NotificationCenter.default.post(name: NSNotification.Name("ShowPopUp"), object: nil, userInfo: msg)
                self.navigationController!.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
extension PayAmountVC : PopUpScreenDelegate{
    func popUpScreen() {
        if let vc = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC{
            vc.strictlyPrimary = true
            vc.fromSettings = true
        }
    }
}
extension PayAmountVC : BuyEventThruCardDelegate
{
    /*func goBackToVC(){
     for vc in self.navigationController?.viewControllers ?? [] {
     if let home = vc as? HomeVC {
     self.navigationController?.popToViewController(home, animated: true)
     break
     }
     }
     }*/
    func buyEventThruCard(cvv:String,cardName:String,cardNumber:String,cardID:String)
    {
        self.cvv = cvv
        self.cardID = cardID
        var cardNo = cardNumber
        self.img_bank_paypaz.image = UIImage(named: "\(cardName)")
        let firstIndex = cardNumber.index(cardNo.startIndex, offsetBy: 12)
        if cardNo.count < 19{
            cardNo.replaceSubrange((firstIndex...),with: "XX XXX")
        }
        else{
            cardNo.replaceSubrange((firstIndex...),with: "XX XXXX")
        }
        self.lbl_id_accountNum.text = cardNo
    }
}
extension PayAmountVC : PaymentDelegate
{
    func didRecieveDataUpdate1(data: Basic_Model)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let msg = ["Message":data.message ?? ""]
            for vc in self.navigationController!.viewControllers as Array {
                if vc.isKind(of:HomeVC.self) {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPopUp"), object: nil, userInfo: msg)
                    self.navigationController!.popToViewController(vc, animated: true)
                    break
                }
            }
//            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
//
//                popup.delegate  = self
//                if let type = self.selectedPayType {
//                    if type == .paypaz {
//                        popup.selectedPopupType = .PayMoneyToContacts
//                    } else if type == .QRCode {
//                        popup.selectedPopupType = .PayMoneyToContacts
//                    } else {
//                        popup.selectedPopupType = .EventAmountPaid
//                    }
//                }
//
//            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            //view.makeToast(data.message ?? "")
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

extension PayAmountVC : LogInDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.userDetails["userImage"] = data.data?.userProfile ?? ""
            self.lbl_id_accountNum.text = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
            self.userDetails["userName"] = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
            self.userDetails["ticketPrice"] = "\(totalPrice ?? 0)"
            self.hostImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url =  APIList().getUrlString(url: .USERIMAGE)
            self.hostImage.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
            self.hostNameLabel.text = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
        }
        else
        {
            view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError1(error: Error)
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
