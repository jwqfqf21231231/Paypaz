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
    @IBOutlet weak var notificationIcon : UIButton!
    @IBOutlet weak var cartCountLabel : UILabel!{
        didSet{
            cartCountLabel.layer.cornerRadius = cartCountLabel.frame.height/2
            cartCountLabel.layer.masksToBounds = true
        }
    }
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.getNotification_Dot() == true{
            notificationIcon.setImage(UIImage(named: "bell_green"), for: .normal)
        }
        else{
            notificationIcon.setImage(UIImage(named: "bell_white"), for: .normal)
        }
        if UserDefaults.standard.object(forKey: "CartCount") != nil{
            cartCountLabel.text = "\(String(describing: (UserDefaults.standard.object(forKey: "CartCount") as! Int)))"
        }
        else{
            cartCountLabel.alpha = 0
        }
        setNotificationStatus()
        swt_Notification.addTarget(self, action: #selector(notificationChange(_:)), for: .valueChanged)
    }
    private func setNotificationStatus()
    {
        
        if UserDefaults.standard.value(forKey: "isNotification") as? String == "0"
        {
            swt_Notification.setOn(false, animated: false)
            swt_Notification.thumbTintColor = UIColor.lightGray
        }
        else
        {
            swt_Notification.setOn(true, animated: false)
            swt_Notification.thumbTintColor = UIColor(named: "GreenColor")
        }
        
        
    }
    @objc func notificationChange(_ sender : UISwitch)
    {
        dataSource.delegate = self
        Connection.svprogressHudShow(view: self)
        if sender.isOn == true
        {
            dataSource.status = "1"
            UserDefaults.standard.setValue("1", forKey: "isNotification")
            swt_Notification.thumbTintColor = UIColor(named: "GreenColor")
        }
        else
        {
            dataSource.status = "0"
            UserDefaults.standard.setValue("0", forKey: "isNotification")
            swt_Notification.thumbTintColor = UIColor.lightGray
            
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
        if let vc = self.pushVC("AddBankAccountVC") as? AddBankAccountVC{
            vc.delegate = self
        }
    }
    @IBAction func btn_AddCardDetails(_ sender:UIButton) {
        _ = self.pushVC("PaymentCardsVC")
//        if let cardVC = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC {
//            cardVC.fromSettings = true
//            cardVC.isAddingNewCard = false
//        }
    }
    @IBAction func btn_TermsPolicies(_ sender:UIButton) {
        _ = self.pushVC("TermsPoliciesVC")
    }
    @IBAction func btn_ContactUs(_ sender:UIButton) {
        if let vc = self.pushVC("ContactUsVC") as? ContactUsVC{
            vc.delegate = self
        }
    }
    @IBAction func btn_ChangePassword(_ sender:UIButton) {
        if let vc = self.pushVC("ChangePasswordVC") as? ChangePasswordVC{
            vc.delegate = self
        }
    }
    @IBAction func btn_ChangePhoneNumber(_ sender:UIButton)
    {
        _ = self.pushVC("EditPhoneNoVC")
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SettingsVC : ContactUsSendStatus{
    func contactUsSendStatus(){
        self.view.makeToast("Mail has been sent")
    }
}
extension SettingsVC : PopupDelegate{
    func isClickedButton() {
        self.view.makeToast("Bank Account Saved Successfully")
    }
}
extension SettingsVC : UpdatedSuccessfullyPopup
{
    func showPopUp(){
        self.view.makeToast("Password updated successfully")
    }
}
extension SettingsVC : NotificationModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            //view.makeToast(data.message ?? "")
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
