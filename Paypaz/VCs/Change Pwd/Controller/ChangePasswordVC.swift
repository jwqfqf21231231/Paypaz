//
//  ChangePasswordVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol UpdatedSuccessfullyPopup:class{
    func showPopUp()
}
class ChangePasswordVC : CustomViewController {
    private let dataSource = ChangePasswordDataModel()
    @IBOutlet weak var btn_OldPwdEye : UIButton!
    @IBOutlet weak var txt_OldPwd : RoundTextField!
    @IBOutlet weak var txt_NewPassword : RoundTextField!
    @IBOutlet weak var txt_ConfirmPassword : RoundTextField!
    @IBOutlet weak var lbl_title  : UILabel!
    @IBOutlet weak var txt_oldPwdHeight : NSLayoutConstraint!
    @IBOutlet weak var txt_NewPwdTop : NSLayoutConstraint!
    
    var hideOldPassword : Bool?
    weak var delegate : UpdatedSuccessfullyPopup?
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
        
       
        if self.hideOldPassword ?? false {
            self.lbl_title.text = "Reset Password"
            txt_oldPwdHeight.constant = 0
            txt_OldPwd.layoutIfNeeded()
        }
        self.txt_OldPwd.isHidden = self.hideOldPassword ?? false
        self.btn_OldPwdEye.isHidden = self.hideOldPassword ?? false
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
        
        if self.hideOldPassword ?? false {
            
            if txt_NewPassword.isEmptyOrWhitespace(){
                view.makeToast("please enter new password")
            }
            else if !txt_NewPassword.validatePassword()
            {
                view.makeToast("Password must be a minimum of 8 characters and include a capital letter, numerical digit and special character.")
            }
            else if txt_ConfirmPassword.isEmptyOrWhitespace(){
                view.makeToast("please enter confirm password")
            }
            else if txt_NewPassword.text?.trim() != txt_ConfirmPassword.text?.trim()
            {
                view.makeToast("Password and confirm Password must match")
            }
            else
            {
                Connection.svprogressHudShow(view: self)
                dataSource.newPassword = txt_NewPassword.text!
                dataSource.hideOldPassword = true
                dataSource.requestPasswordChange()
            }
        }
        else {
            if txt_OldPwd.text?.trim().count == 0{
                view.makeToast("please enter old password")
            }
            else if txt_NewPassword.text?.trim().count == 0{
                view.makeToast("please enter new password")
            }
            else if !txt_NewPassword.validatePassword()
            {
                view.makeToast("Password must be a minimum of 8 characters and include a capital letter, numerical digit and special character.")
            }
            else if txt_ConfirmPassword.text?.trim().count == 0{
                view.makeToast("please enter confirm password")
            }
            else if txt_NewPassword.text?.trim() != txt_ConfirmPassword.text?.trim()
            {
                view.makeToast("Password and confirm Password must match")
            }
            else
            {
                Connection.svprogressHudShow(view: self)
                dataSource.oldPassword = txt_OldPwd.text!
                dataSource.newPassword = txt_NewPassword.text!
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
                        view.makeToast(data.message)
                    }
                }
            }
            else {
                self.delegate?.showPopUp()
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
