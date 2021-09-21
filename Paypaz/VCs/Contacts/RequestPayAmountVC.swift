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
    @IBOutlet weak var view_FromInfo  : UIView!
    @IBOutlet weak var view_Receiving : UIView!
    @IBOutlet weak var view_ConversionAmount : UIView!
    
    var selectedPaymentType : PaymentType?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_userInfo.alpha = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    @IBAction func btn_Request(_ sender:RoundButton){
        if let contacts = self.pushVC("ContactListVC") as? ContactListVC {
            let local = (self.selectedPaymentType == PaymentType.local)
            contacts.isLocalContactSelected = local
            contacts.isRequestingMoney = true
            contacts.delegate = self
        }
        
    }
    @IBAction func btn_Pay(_ sender:RoundButton){
        if let contacts = self.pushVC("ContactListVC") as? ContactListVC {
            let local = (self.selectedPaymentType == PaymentType.local)
            contacts.isLocalContactSelected = local
            contacts.isRequestingMoney = false
            contacts.delegate = self
        }
        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                if let popup = self?.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                    //  popup.delegate = self
                    popup.selectedPopupType = .PaymentRequestSent
                }
            }
        }
        else{
            _ = self.pushVC("EnterPinVC")
        }
    }
}
