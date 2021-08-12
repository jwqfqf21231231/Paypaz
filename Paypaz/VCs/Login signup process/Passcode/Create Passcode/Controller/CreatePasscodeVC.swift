//
//  CreatePasscodeVC.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CreatePasscodeVC: CustomViewController {
    
    
    var setNewPasscode : Bool?
    weak var delegate : PopupDelegate?
    var typedPasscode = ""
    var hasEntered = false
    
    // MARK:- ---
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var otpView: VPMOTPView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedArround()
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBackgroundColor = UIColor.white
        otpView.delegate = self
        otpView.shouldRequireCursor = false
        otpView.shouldAllowIntermediateEditing = false
        otpView.otpFieldEntrySecureType = true
        otpView.changeStateOfTextField()
        otpView.initializeUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.setNewPasscode ?? false
        {
            self.lbl_Title.text = "New Passcode"
        }
        else
        {
            self.lbl_Title.text = "Create Passcode"
        }
    }
    
    @IBAction func btn_Next(_ sender:UIButton) {
        
        if let vc = self.pushToVC("ConfirmPasscodeVC") as? ConfirmPasscodeVC
        {
            vc.createdPasscode = typedPasscode
        }
    }
    
}
extension CreatePasscodeVC : VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        self.hasEntered = hasEntered
        return hasEntered
    }
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        if hasEntered && index < 3
        {
            return false
        }
        else
        {
            return true
        }
    }
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        self.typedPasscode = otpString
    }
}
