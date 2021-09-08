//
//  ConfirmPasscodeVC.swift
//  Paypaz
//
//  Created by MACOSX on 05/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Toast_Swift
class ConfirmPasscodeVC: CustomViewController {
    
    weak var delegate : PopupDelegate?
    var createdPasscode = ""
    var typedPasscode = ""
    var hasEntered = false
    private let dataSource = ConfirmPasscodeDataModel()
    // MARK:- ---
    @IBOutlet weak var otpView: VPMOTPView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        hideKeyboardWhenTappedArround()
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBackgroundColor = UIColor.white
        otpView.delegate = self
        otpView.shouldRequireCursor = false
        otpView.shouldAllowIntermediateEditing = false
        otpView.otpFieldEntrySecureType = true
        otpView.changeStateOfTextField()
        otpView.initializeUI()
    }
    
    @IBAction func btn_Submit(_ sender:UIButton) {
        
        if(createdPasscode == typedPasscode)
        {
            Connection.svprogressHudShow(view: self)
            dataSource.passcode = typedPasscode
            dataSource.createPasscode()
        }
        else
        {
            self.view.makeToast("Enter the Same Passcode", duration: 3, position: .bottom)
        }
        
    }
}
extension ConfirmPasscodeVC: VPMOTPViewDelegate {
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
extension ConfirmPasscodeVC : ConfirmPasscodeDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.set(data.data?.isPasscode, forKey: "isPasscode")
            UserDefaults.standard.setPasscode(value: data.data?.passcode ?? "")
            if UserDefaults.standard.value(forKey: "isPin") as? String == "1"
            {
                _ = self.pushVC("SideDrawerBaseVC")
            }
            else
            {
                if let createVc = self.pushVC("CreatePinVC") as? CreatePinVC{
                    createVc.isCreatingPin = true
                }
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
