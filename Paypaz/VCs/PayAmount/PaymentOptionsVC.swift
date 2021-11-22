//
//  PaymentOptionsVC.swift
//  Paypaz
//
//  Created by MAC on 28/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage


class PaymentOptionsVC: UIViewController {
    
    @IBOutlet weak var btn_Submit      : RoundButton!
    @IBOutlet weak var view_id_Description : UIView!
    @IBOutlet weak var view_QRCode       : UIView!
    @IBOutlet weak var lbl_id_accountNum : UILabel!
    @IBOutlet weak var txt_Description  : UITextView!
    @IBOutlet weak var img_bank_paypaz  : UIImageView!
    @IBOutlet weak var view_line1       : UIView!
    @IBOutlet weak var view_line2       : UIView!
    @IBOutlet weak var hostImage : UIImageView!
    @IBOutlet weak var hostNameLabel : UILabel!
    @IBOutlet weak var totalPriceLabel : UILabel!
    @IBOutlet weak var paypazAccount : UILabel!
    var selectedPayType : PayType?
    var cartInfo : UpdatedCartInfo?
    var userDetails = [String:String]()
    private let dataSource = PaymentDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.updateUI(with: selectedPayType ?? .paypaz)
        displayUserDetails()
    }
    
    private func displayUserDetails(){
        self.hostImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .USERIMAGE)
        self.hostImage.sd_setImage(with: URL(string: url+(userDetails["userImage"] ?? "")), placeholderImage: UIImage(named: "profile_c"))
        self.hostNameLabel.text = userDetails["userName"]
        self.paypazAccount.text = userDetails["userName"]
        self.totalPriceLabel.text = "$\(userDetails["ticketPrice"] ?? "")"
    }
    
    private func updateUI(with type : PayType) {
        
        if type == .paypaz || type == .BankAcc {
            self.view_id_Description.isHidden = false
            self.view_line1.isHidden          = false
            self.view_line2.isHidden          = false
            self.btn_Submit.isHidden          = false
            self.view_QRCode.isHidden         = true
            
            if type == .BankAcc {
                self.img_bank_paypaz.image  = UIImage(named: "surface")
                self.lbl_id_accountNum.text = "Account No : 03213543467567"
            }
            
        } else if type == .QRCode {
            self.btn_Submit.isHidden          = false
            self.view_id_Description.isHidden = true
            self.view_line1.isHidden          = true
            self.view_line2.isHidden          = true
            self.view_QRCode.isHidden         = false
        }
    }
    
    @IBAction func btn_Submit(_ sender:UIButton) {
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
        if selectedPayType == .paypaz {
            dataSource.paymentMethod = "1"
        }
        else{
            dataSource.paymentMethod = "2"
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(cartInfo?.products)
        dataSource.products = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""//String(data: data, encoding: .utf8)!
        dataSource.requestPayment()
    }
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PaymentOptionsVC : PopupDelegate {
    func isClickedButton() {
        for vc in self.navigationController!.viewControllers as Array {
            if vc.isKind(of:HomeVC.self) {
                self.navigationController!.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
extension PaymentOptionsVC : PaymentDelegate
{
    func didRecieveDataUpdate1(data: Basic_Model)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
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
        else
        {
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.unauthorized = true
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
