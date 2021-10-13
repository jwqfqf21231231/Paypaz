//
//  EnterPinVC.swift
//  Paypaz
//
//  Created by MAC on 21/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol SendBackPinCodeDelegate : class{
    func sendBackPinCode(pin:String)
}
class EnterPinVC: UIViewController {
    
    var hasEntered = false
    var enteredPin = ""
    var cartInfo : UpdatedCartInfo?
    var paymentMethod : String?
    weak var delegate : SendBackPinCodeDelegate?
    @IBOutlet weak var otpView: VPMOTPView!
    private let passcodeDataSource = PasscodeDataModel()

    private let dataSource = PaymentDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeDataSource.delegate2 = self
        otpView.delegate = self
        otpView.otpFieldEntrySecureType = true
        otpView.initializeUI()
        otpView.changeStateOfTextField()
        hideKeyboardWhenTappedArround()
    }
    
    @IBAction func btn_Back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_show(_ sender:UIButton) {
        otpView.otpFieldEntrySecureType = !otpView.otpFieldEntrySecureType
        otpView.changeStateOfTextField()
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    @IBAction func btn_ForgotPin(_ sender:UIButton) {
        Connection.svprogressHudShow(view: self)
        passcodeDataSource.getOTP()
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if !hasEntered
        {
            self.view.makeToast("Enter Pin", duration: 3, position: .bottom)
        }
        else{
            self.delegate?.sendBackPinCode(pin: self.enteredPin)
            self.navigationController?.popViewController(animated: false)
        }
        
//        if !hasEntered
//        {
//            self.view.makeToast("Enter Pin", duration: 3, position: .bottom)
//        }
//        else
//        {
//            if self.enteredPin != UserDefaults.standard.getPin(){
//                self.view.makeToast("Enter Valid Pin", duration: 3, position: .bottom)
//            }
//            else{
//                self.navigationController?.popViewController(animated: true)
//                //                self.delegate?.isClickedButton()
//            }
//        }
    }
}
extension EnterPinVC : ForgotPasscodeDataModelDelegate
{
    
    func didRecieveDataUpdate(data: ForgotPasscodeModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let OTPVerificationVC = self.pushVC("OTPVerificationVC",animated:false) as? OTPVerificationVC{
                OTPVerificationVC.doForgotPincode = true
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
extension EnterPinVC:VPMOTPViewDelegate{
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
    
    func enteredOTP(otpString: String, tag: Int) {
        print("OTPString: \(otpString)")
        self.enteredPin = otpString
    }
}
