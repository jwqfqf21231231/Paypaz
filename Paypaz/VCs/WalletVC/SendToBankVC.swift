//
//  SendToBankVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class SendToBankVC : CustomViewController {
    
    //MARK:- ----
    @IBOutlet weak var btn_Local      : UIButton!
    @IBOutlet weak var btn_Global     : UIButton!
    @IBOutlet weak var view_Local     : UIView!
    @IBOutlet weak var view_Global    : UIView!
    @IBOutlet weak var view_FromInfo  : UIView!
    @IBOutlet weak var view_Receiving : UIView!
    @IBOutlet weak var view_ConversionAmount : UIView!
    
    private var isLocalContactSelected : Bool?
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectLocalPayment()
        
    }
    
    
    private func selectLocalPayment() {
        self.isLocalContactSelected = true
        
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Local.backgroundColor  = lightBlue
        self.view_Global.backgroundColor = .clear
        
        self.btn_Local.setTitleColor(.white, for: .normal)
        self.btn_Global.setTitleColor(lightBlue, for: .normal)
        
        self.view_FromInfo.isHidden         = true
        self.view_Receiving.isHidden        = true
        self.view_ConversionAmount.isHidden = true
    }
    private func selectGlobalPayment() {
        self.isLocalContactSelected = false
        
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Global.backgroundColor = lightBlue
        self.view_Local.backgroundColor  = .clear
        
        self.btn_Global.setTitleColor(.white, for: .normal)
        self.btn_Local.setTitleColor(lightBlue, for: .normal)
        
        self.view_FromInfo.isHidden         = false
        self.view_Receiving.isHidden        = false
        self.view_ConversionAmount.isHidden = false
    }
    @IBAction func btn_LocalPayment(_ sender:UIButton) {
        self.selectLocalPayment()
    }
    @IBAction func btn_GlobalPayment(_ sender:UIButton) {
        self.selectGlobalPayment()
    }
    
    //MARK:- ---- Action ----
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
    @IBAction func btn_Send(_ sender:UIButton) {
        if self.isLocalContactSelected ?? false {
            if let popupVC = self.presentPopUpVC("MoneyAddedSuccessPopupVC", animated: true) as? MoneyAddedSuccessPopupVC {
               // popupVC.delegate = self
                popupVC.selectedMoneyType = .MoneySentSuccess
            }
        } else {
            if let passcodeVC = self.pushToVC("PasscodeVC") as? PasscodeVC {
                passcodeVC.delegate = self
                passcodeVC.isNavigatedFromPaymentVC = true
            }
        }
        
    }
}
extension SendToBankVC : PopupDelegate {
    func isClickedButton() {
        if self.isLocalContactSelected ?? false { } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                if let popupVC = self?.presentPopUpVC("MoneyAddedSuccessPopupVC", animated: true) as? MoneyAddedSuccessPopupVC {
                   // popupVC.delegate = self
                    popupVC.selectedMoneyType = .MoneySentSuccess
                }
            }
        }
        
        
    }
}
