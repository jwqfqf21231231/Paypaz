//
//  PayAmountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class PayAmountVC : CustomViewController {
    enum PayType {
        case paypaz
        case BankAcc
        case QRCode
    }
    private var selectedPayType : PayType?
    
    @IBOutlet weak var stackView_Width : NSLayoutConstraint!
    @IBOutlet weak var btn_PayByPaypaz : RoundButton!
    @IBOutlet weak var btn_PayByQR     : RoundButton!
    @IBOutlet weak var btn_PayByBank   : RoundButton!
    @IBOutlet weak var btn_Submit      : RoundButton!
    @IBOutlet weak var view_id_Description : UIView!
    @IBOutlet weak var view_QRCode       : UIView!
    @IBOutlet weak var lbl_id_accountNum : UILabel!
    @IBOutlet weak var txt_Description  : UITextField!
    @IBOutlet weak var img_bank_paypaz  : UIImageView!
    @IBOutlet weak var view_line1       : UIView!
    @IBOutlet weak var view_line2       : UIView!
    
    
   /* @IBOutlet weak var hostImage : UIImageView!
    @IBOutlet weak var hostNameLabel : UILabel!
    @IBOutlet weak var totalAmountLabel : UILabel!
    @IBOutlet weak var btn_PayByPaypaz : RoundButton!
    @IBOutlet weak var btn_PayByQR     : RoundButton!
    @IBOutlet weak var btn_PayByBank   : RoundButton!*/
    private let userProfileDataSource = LogInDataModel()
    var userDetails = [String:String]()
    var totalPrice : Int?
    var cartInfo : UpdatedCartInfo?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_Submit.isHidden  = true
        self.view_id_Description.isHidden = true
        self.view_line1.isHidden  = true
        self.view_line2.isHidden  = true
        self.view_QRCode.isHidden = true
        
        /*self.totalAmountLabel.text = "$\(totalPrice ?? 0)"
        getUserProfile()*/
    }
    private func updateUI(with type : PayType) {
        self.selectedPayType = type
       // self.stackView_Width.priority = UILayoutPriority(rawValue: 999)
        
        if type == .paypaz || type == .BankAcc {
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
            self.btn_Submit.isHidden          = false
            self.btn_PayByPaypaz.isHidden     = true
            self.btn_PayByQR.isHidden         = true
            self.btn_PayByBank.isHidden       = true
            self.view_QRCode.isHidden         = false
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
    @IBAction func btn_PayByPaypaz(_ sender:UIButton) {
        
        self.updateUI(with: .paypaz)
    }
    @IBAction func btn_PayByQRCode(_ sender:UIButton) {
        self.updateUI(with: .QRCode)
    }
    @IBAction func btn_PayByBankAcc(_ sender:UIButton) {
        self.updateUI(with: .BankAcc)
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        
        if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
            popup.delegate  = self
            if let type = self.selectedPayType {
                if type == .paypaz {
                  popup.selectedPopupType = .PayMoneyToContacts
                } else if type == .QRCode {
                  popup.selectedPopupType = .PayMoneyToContacts
                } else {
                  popup.selectedPopupType = .EventAmountPaid
                }
            }
            
        }
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
extension PayAmountVC : PopupDelegate {
    func isClickedButton() {
        self.navigationController?.popViewController(animated: true)
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
extension PayAmountVC : PaymentSuccessfulDelegate
{
    func goBackToVC(){
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
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
            self.userDetails["userName"] = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
            self.userDetails["ticketPrice"] = "\(totalPrice ?? 0)"
           
           /* self.hostImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url =  APIList().getUrlString(url: .USERIMAGE)
            self.hostImage.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
            self.hostNameLabel.text = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")*/
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
