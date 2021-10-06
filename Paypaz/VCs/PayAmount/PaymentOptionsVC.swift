//
//  PaymentOptionsVC.swift
//  Paypaz
//
//  Created by MAC on 28/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
enum PayType {
    case paypaz
    case BankAcc
    case QRCode
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
