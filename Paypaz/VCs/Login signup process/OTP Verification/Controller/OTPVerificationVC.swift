//
//  OTPVerificationVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Toast_Swift
class OTPVerificationVC : CustomViewController {
    var doForgotPasscode : Bool?
    var doForgotPassword : Bool?
    private let dataSource = OTPVerificationDataModel()
    // MARK:- ---
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var lbl_Notify : UILabel!
    @IBOutlet weak var txt_Field_1 : UITextField!
    @IBOutlet weak var txt_Field_2 : UITextField!
    @IBOutlet weak var txt_Field_3 : UITextField!
    @IBOutlet weak var txt_Field_4 : UITextField!
    
    var email = UserDefaults.standard.getEmail()
    var password = ""
    var verifyOTP = ""
    //To Save Typed OTP Characters
    var otpString = ""
    //OTP sent by PasscodeVC
    var passcodeOTP = ""
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle()
        self.hideKeyboardWhenTappedAround()
        self.setDelegates()
        self.actionToTextFields()
        self.setLabel()
        dataSource.delegate = self
        dataSource.delegate1 = self
        dataSource.delegate2 = self
        dataSource.delegate3 = self
    }
    private func changeTitle()
    {
        if doForgotPasscode ?? false
        {
            lbl_Title.text = "Passcode OTP Verification"
            
        }
        else
        {
            lbl_Title.text = "OTP Verification"
        }
    }
    private func setLabel()
    {
        let attributedText = NSMutableAttributedString(string: "Enter OTP Code sent to", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)])
        attributedText.append(NSAttributedString(string: " \(email)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 82/255, blue: 136/255, alpha: 1)]))
        lbl_Notify.numberOfLines=0
        lbl_Notify.attributedText = attributedText
        lbl_Notify.textAlignment = .center
    }
    
    private func setDelegates(){
        self.txt_Field_1.delegate  = self
        self.txt_Field_2.delegate  = self
        self.txt_Field_3.delegate  = self
        self.txt_Field_4.delegate  = self
    }
    
    private func actionToTextFields(){
        txt_Field_1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txt_Field_2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txt_Field_3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txt_Field_4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField {
            case txt_Field_1:
                otpString += textField.text!
                txt_Field_2.becomeFirstResponder()
            case txt_Field_2:
                otpString += textField.text!
                txt_Field_3.becomeFirstResponder()
            case txt_Field_3:
                otpString += textField.text!
                txt_Field_4.becomeFirstResponder()
            case txt_Field_4:
                otpString += textField.text!
                txt_Field_4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txt_Field_1:
                otpString.removeLast()
                txt_Field_1.becomeFirstResponder()
            case txt_Field_2:
                otpString.removeLast()
                txt_Field_1.becomeFirstResponder()
            case txt_Field_3:
                otpString.removeLast()
                txt_Field_2.becomeFirstResponder()
            case txt_Field_4:
                otpString.removeLast()
                txt_Field_3.becomeFirstResponder()
            default:
                break
            }
        }
        else {
            
        }
    }
    // MARK:- --- Action ----
    @IBAction func btn_Resend(_ sender:UIButton) {
        dataSource.email = email
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.resendOTP()
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if(txt_Field_1.text?.isEmpty == true || txt_Field_2.text?.isEmpty == true || txt_Field_3.text?.isEmpty == true || txt_Field_4.text?.isEmpty == true)
        {
            self.showAlert(withMsg: "Please enter OTP", withOKbtn: true)
        }
        else
        {
            if self.doForgotPassword ?? false
            {
                if verifyOTP == otpString
                {
                    dataSource.otp = verifyOTP
                    dataSource.doForgotPassword = true
                    Connection.svprogressHudShow(title: "Please wait", view: self)
                    dataSource.verifyOTP()
                }
                else
                {
                    self.view.makeToast("Please check your OTP and enter again", duration: 3, position: .bottom)
                }
                
            }
            if self.doForgotPasscode ?? false{
                if passcodeOTP == otpString
                {
                    dataSource.passcodeOTP = passcodeOTP
                    Connection.svprogressHudShow(title: "Please wait", view: self)
                    dataSource.forgotPasscodeOTPVerify()
                }
                else
                {
                    self.view.makeToast("Please check your OTP and enter again", duration: 3, position: .bottom)
                }
                
            }
            else
            {
                dataSource.email = email
                dataSource.password = password
                dataSource.otp = verifyOTP
                dataSource.userTypedOTP = otpString
                Connection.svprogressHudShow(title: "Please Wait", view: self)
                dataSource.verifyOTP()
            }
        }
    }
}

//MARK:- ---- Extension ----
extension OTPVerificationVC : PopupDelegate {
    func isClickedButton() {
        _ = self.pushToVC("CreateProfileVC")
    }
}
extension OTPVerificationVC : ForgotPasswordOTPModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel) {
        print("ForgotPasswordOTPModelData = ",data)
        
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            viewController.hideOldPassword = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
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

extension OTPVerificationVC : OTPVerificationDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        print("OTPModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.setLoggedIn(value: true)
            UserDefaults.standard.setRegisterToken(value: (data.data?.token ?? ""))
            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                popup.delegate = self
            }
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
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

extension OTPVerificationVC : ResendOTPModelDelegate
{
    func didRecieveDataUpdate2(data: ResendOTPModel)
    {
        print("ResendOTPModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.view.makeToast("OTP Sent Successfully", duration: 3, position: .bottom)
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError2(error: Error)
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
extension OTPVerificationVC : ForgotPasscodeVerifyOTPModelDelegate
{
    func didRecieveDataUpdate3(data: ResendOTPModel)
    {
        print("ForgotPasscodeOTPModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let CreatePasscodeVC = self.pushToVC("CreatePasscodeVC") as? CreatePasscodeVC
            {
                CreatePasscodeVC.setNewPasscode = true
            }
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError3(error: Error)
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
