//
//  ChangePasswordVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ChangePasswordVC : CustomViewController {
    private let dataSource = ChangePasswordDataModel()
    @IBOutlet weak var btn_OldPwdEye : UIButton!
    @IBOutlet weak var txt_OldPwd : RoundTextField!
    @IBOutlet weak var txt_NewPassword : RoundTextField!
    @IBOutlet weak var txt_ConfirmPassword : RoundTextField!
    @IBOutlet weak var lbl_title  : UILabel!
    
    var hideOldPassword : Bool?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.setDelegate()
    }
    private func setDelegate(){
        self.txt_OldPwd.delegate    = self
        self.txt_NewPassword.delegate = self
        self.txt_ConfirmPassword.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.txt_OldPwd.isHidden = self.hideOldPassword ?? false
        self.btn_OldPwdEye.isHidden = self.hideOldPassword ?? false
        if self.hideOldPassword ?? false {
            self.lbl_title.text = "Reset Password"
        }
       
    }

    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
       self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btn_Eye(_ sender:UIButton)
    {
        switch sender.tag {
        case 101:
            self.txt_OldPwd.isSecureTextEntry = !txt_OldPwd.isSecureTextEntry
            if(txt_OldPwd.isSecureTextEntry)
            {
                sender.setImage(UIImage(named: "password"), for: .normal)
            }
            else
            {
                sender.setImage(UIImage(named: "show_eye"), for: .normal)
            }
        case 102:
            self.txt_NewPassword.isSecureTextEntry = !txt_NewPassword.isSecureTextEntry
            if(txt_NewPassword.isSecureTextEntry)
            {
                sender.setImage(UIImage(named: "password"), for: .normal)
            }
            else
            {
                sender.setImage(UIImage(named: "show_eye"), for: .normal)
            }
        default:
            self.txt_ConfirmPassword.isSecureTextEntry = !txt_ConfirmPassword.isSecureTextEntry
            if(txt_ConfirmPassword.isSecureTextEntry)
            {
                sender.setImage(UIImage(named: "password"), for: .normal)
            }
            else
            {
                sender.setImage(UIImage(named: "show_eye"), for: .normal)
            }
        }
    }
    @IBAction func btn_Done(_ sender:UIButton) {
        let oldPassword = txt_OldPwd.text?.trimmingCharacters(in: .whitespaces)
        let newPassword = txt_NewPassword.text?.trimmingCharacters(in: .whitespaces)
        let confPassword = txt_ConfirmPassword.text?.trimmingCharacters(in: .whitespaces)
        
        if self.hideOldPassword ?? false {
            
            if newPassword == ""{
                self.showAlert(withMsg: "please enter new password", withOKbtn: true)
            }
            else if confPassword == ""{
                self.showAlert(withMsg: "please enter confirm password", withOKbtn: true)
            }
            else if newPassword != confPassword
            {
                self.showAlert(withMsg: "Password and confirm Password must match", withOKbtn: true)
            }
            else
            {
                Connection.svprogressHudShow(view: self)
                dataSource.newPassword = newPassword!
                dataSource.hideOldPassword = true
                dataSource.requestPasswordChange()
            }
        }
        else {
            if oldPassword == ""{
                self.showAlert(withMsg: "please enter old password", withOKbtn: true)
            }
            else if newPassword == ""{
                self.showAlert(withMsg: "please enter new password", withOKbtn: true)
            }
            else if confPassword == ""{
                self.showAlert(withMsg: "please enter confirm password", withOKbtn: true)
            }
            else if newPassword != confPassword
            {
                self.showAlert(withMsg: "Password and confirm Password must match", withOKbtn: true)
            }
            else
            {
                Connection.svprogressHudShow(view: self)
                dataSource.oldPassword = oldPassword!
                dataSource.newPassword = newPassword!
                dataSource.requestPasswordChange()
            }
        }
    
    }
}
extension ChangePasswordVC : ChangePasswordDataModelDelegate
{
    func didRecieveDataUpdate(data: ChangePasswordModel)
    {
        print("ChangePasswordModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if self.hideOldPassword ?? false {
                for vc in self.navigationController?.viewControllers ?? [] {
                    if let login = vc as? LoginVC {
                        self.navigationController?.popToViewController(login, animated: false)
                    }
                }
            }
            else {
                self.navigationController?.popViewController(animated: false)
            }
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
