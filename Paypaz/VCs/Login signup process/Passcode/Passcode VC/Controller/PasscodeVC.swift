//
//  PasscodeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class PasscodeVC : CustomViewController {
    
    weak var delegate : PopupDelegate?
    var typedPasscode = ""
    var otp = ""
    var hasEntered = false
    private let dataSource = PasscodeDataModel()
    @IBOutlet weak var otpView: VPMOTPView!
    var isNavigatedFromPaymentVC : Bool?
    
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        hideKeyboardWhenTappedArround()
        
        otpView.otpFieldEntrySecureType = true
        otpView.initializeUI()
        otpView.changeStateOfTextField()
    }
    func setDelegates()
    {
        otpView.delegate = self
        dataSource.delegate = self
        dataSource.delegate2 = self
    }
    // MARK:- --- Action ----
    @IBAction func btn_ForgotPasscode(_ sender:UIButton) {
        Connection.svprogressHudShow(view: self)
        dataSource.getOTP()
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if self.isNavigatedFromPaymentVC ?? false {
            self.navigationController?.popViewController(animated: true)
            //self.delegate?.isClickedButton()
        } else {
            Connection.svprogressHudShow(view: self)
            dataSource.passcode = typedPasscode
            dataSource.validatePasscode()
        }
        
    }
}
extension PasscodeVC: VPMOTPViewDelegate {
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
        self.typedPasscode = otpString
    }
}
extension PasscodeVC : PasscodeDataModelDelegate
{
    
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            _ = self.pushVC("SideDrawerBaseVC")
        }
        else
        {
            view.makeToast(data.message)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
extension PasscodeVC : ForgotPasscodeDataModelDelegate
{
    
    func didRecieveDataUpdate(data: ForgotPasscodeModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let OTPVerificationVC = self.pushVC("OTPVerificationVC",animated:false) as? OTPVerificationVC{
                OTPVerificationVC.doForgotPasscode = true
            }
        }
        else
        {
            showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError2(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
