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
    var doForgotPincode : Bool?
    var doChangePhoneNumber : Bool?
    private let dataSource = OTPVerificationDataModel()
    private let dataSource1 = EditPhoneNoDataModel()
    
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var lbl_Notify : UILabel!
    @IBOutlet weak var otpView: VPMOTPView!
    
    var email = ""
    var phoneNumber = ""
    var hasEntered = false
    //To Save Typed OTP Characters
    var otpString = ""
    
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle()
        hideKeyboardWhenTappedArround()
        setDelegates()
        otpView.initializeUI()
    }
    
    func setDelegates()
    {
        dataSource.delegate = self
        dataSource.delegate1 = self
        dataSource.delegate2 = self
        dataSource.delegate3 = self
        dataSource.delegate4 = self
        dataSource1.delegate1 = self
        otpView.delegate = self
    }
    
    private func changeTitle()
    {
        if doForgotPincode ?? false{
            lbl_Title.text = "Pin OTP Verification"
            lbl_Notify.text = "\(UserDefaults.standard.getPhoneCode()) " + "\(UserDefaults.standard.getPhoneNo())"
        }
        else if doForgotPasscode ?? false
        {
            lbl_Title.text = "Passcode OTP Verification"
            lbl_Notify.text = "\(UserDefaults.standard.getPhoneCode()) " + "\(UserDefaults.standard.getPhoneNo())"
        }
        else if  doForgotPassword ?? false
        {
            lbl_Title.text = "Password OTP Verification"
            if email != ""
            {
                lbl_Notify.text = email
            }
            else
            {
                lbl_Notify.text = "\(UserDefaults.standard.getPhoneCode()) " + phoneNumber
            }
        }
        else if doChangePhoneNumber ?? false
        {
            lbl_Title.text = "OTP Verification"
            lbl_Notify.text = "\(UserDefaults.standard.getPhoneCode()) " + phoneNumber
        }
        else
        {
            lbl_Title.text = "OTP Verification"
            lbl_Notify.text = "\(UserDefaults.standard.getPhoneCode()) " + UserDefaults.standard.getPhoneNo()
        }
    }
    
    // MARK:- --- Action ----
    @IBAction func btn_Resend(_ sender:UIButton) {
        if doChangePhoneNumber ?? false
        {
            Connection.svprogressHudShow(view: self)
            dataSource1.phoneNumber = phoneNumber
            dataSource1.phoneCode = UserDefaults.standard.getPhoneCode()
            dataSource1.resendOTP()
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.resendOTP()
        }
    }
    
    @IBAction func btn_Submit(_ sender:UIButton) {
        if !hasEntered
        {
            view.makeToast("Please enter OTP")
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            if self.doForgotPassword ?? false
            {
                dataSource.otp = otpString
                dataSource.doForgotPassword = true
                dataSource.verifyOTP()
            }
            else if self.doForgotPasscode ?? false
            {
                dataSource.otp = otpString
                dataSource.forgotPasscodeOTPVerify()
            }
            else if self.doForgotPincode ?? false
            {
                dataSource.otp = otpString
                dataSource.forgotPasscodeOTPVerify()
            }
            else if self.doChangePhoneNumber ?? false
            {
                dataSource.phoneNumber = phoneNumber
                dataSource.otp = otpString
                dataSource.doVerifyPhoneNumber()
            }
            else
            {
                dataSource.otp = otpString
                dataSource.verifyOTP()
            }
        }
    }
}

//MARK:- ---- Extension ----
extension OTPVerificationVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool,tag:Int) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        self.hasEntered = hasEntered
        return hasEntered
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int,tag:Int) -> Bool {
        if hasEntered && index < 3
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func enteredOTP(otpString: String,tag:Int) {
        print("OTPString: \(otpString)")
        self.otpString = otpString
    }
}

extension OTPVerificationVC : PopupDelegate {
    func isClickedButton() {
        _ = self.pushVC("CreateProfileVC")
        
    }
}

extension OTPVerificationVC : ForgotPasswordOTPModelDelegate
{
    func didRecieveDataUpdate1(data: ResendOTPModel) {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            viewController.hideOldPassword = true
            self.navigationController?.pushViewController(viewController, animated: false)
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

extension OTPVerificationVC : OTPVerificationDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.set(data.data?.isVerify, forKey: "isVerify")
            UserDefaults.standard.setUserID(value: data.data?.id ?? "")
            UserDefaults.standard.setLoggedIn(value: data.data?.isLoggedIN ?? "")
            UserDefaults.standard.setRegisterToken(value: (data.data?.token ?? ""))
            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                popup.selectedPopupType = .PhoneSaved
                popup.delegate = self
            }
        }
        else
        {
            view.makeToast(data.message ?? "")
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
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.view.makeToast(data.message, duration: 3, position: .bottom)
        }
        else
        {
            view.makeToast(data.message ?? "")
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
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if self.doForgotPincode == true{
                if let vc = self.pushVC("CreatePinVC") as? CreatePinVC{
                    vc.isCreatingPin = false
                }
            }
            else{
                if let CreatePasscodeVC = self.pushVC("CreatePasscodeVC") as? CreatePasscodeVC
                {
                    CreatePasscodeVC.setNewPasscode = true
                }
            }
            
        }
        else
        {
            view.makeToast(data.message ?? "")
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

extension OTPVerificationVC : VerifyChangePasswordModelDelegate
{
    func didRecieveDataUpdate4(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            NotificationCenter.default.post(name: NSNotification.Name("ReloadUserDetails"), object: nil)
            UserDefaults.standard.setPhoneNo(value: data.data?.phoneNumber ?? "")
            for vc in self.navigationController!.viewControllers as Array {
                if vc.isKind(of:SettingsVC.self) {
                    self.navigationController!.popToViewController(vc, animated: true)
                    break
                }
            }
        }
        else
        {
            view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError4(error: Error)
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

extension OTPVerificationVC : ResendOTPToChangePhoneNo
{
    func didRecieveDataUpdate5(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            view.makeToast("OTP Resend Successfully")
        }
        else
        {
            self.view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError5(error: Error)
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
