//
//  SettingsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class SettingsVC : CustomViewController {
    
    private let dataSource = NotificationDataModel()
    @IBOutlet weak var swt_Notification : UISwitch!
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationStatus()
        swt_Notification.addTarget(self, action: #selector(notificationChange(_:)), for: .valueChanged)
    }
    private func setNotificationStatus()
    {
        
        if UserDefaults.standard.value(forKey: "isNotification") as? String == "0"
        {
            swt_Notification.setOn(false, animated: false)
            
        }
        else
        {
            swt_Notification.setOn(true, animated: false)
        }
        
        
    }
    @objc func notificationChange(_ sender : UISwitch)
    {
        dataSource.delegate = self
        Connection.svprogressHudShow(view: self)
        if sender.isOn == true
        {
            dataSource.status = "1"
        }
        else
        {
            dataSource.status = "0"
        }
        dataSource.changeNotificationStatus()
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Cart(_ sender:UIButton) {
        _ = self.pushVC("MyCartVC")
    }
    @IBAction func btn_Notification(_ sender:UIButton) {
        _ = self.pushVC("NotificationsListVC")
    }
    @IBAction func btn_AddBank(_ sender:UIButton) {
        _ = self.pushVC("AddBankAccountVC")
    }
    @IBAction func btn_AddCardDetails(_ sender:UIButton) {
        if let cardVC = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC {
            cardVC.fromSettings = true
            cardVC.isAddingNewCard = false
        }
    }
    @IBAction func btn_TermsPolicies(_ sender:UIButton) {
        _ = self.pushVC("TermsPoliciesVC")
    }
    @IBAction func btn_ContactUs(_ sender:UIButton) {
        _ = self.pushVC("ContactUsVC")
    }
    @IBAction func btn_ChangePassword(_ sender:UIButton) {
        _ = self.pushVC("ChangePasswordVC")
    }
    @IBAction func btn_ChangePhoneNumber(_ sender:UIButton)
    {
        _ = self.pushVC("EditPhoneNoVC")
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SettingsVC : NotificationModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            view.makeToast(data.message ?? "")
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
