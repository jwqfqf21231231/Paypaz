//
//  EnterPinVC.swift
//  Paypaz
//
//  Created by MAC on 21/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EnterPinVC: UIViewController {
    
    var hasEntered = false
    var enteredPin = ""
    @IBOutlet weak var otpView: VPMOTPView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func btn_Submit(_ sender:UIButton) {
        if !hasEntered
        {
            self.view.makeToast("Enter Pin", duration: 3, position: .bottom)
        }
        else
        {
            if self.enteredPin != UserDefaults.standard.getPin(){
                self.view.makeToast("Enter Valid Pin", duration: 3, position: .bottom)
            }
            else{
                self.navigationController?.popViewController(animated: true)
                //                self.delegate?.isClickedButton()
            }
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
