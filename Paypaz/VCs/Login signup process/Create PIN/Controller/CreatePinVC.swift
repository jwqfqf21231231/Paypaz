//
//  CreatePinVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CreatePinVC : CustomViewController {
    
    var isCreatingPin : Bool?
    weak var delegate : PopupDelegate?
    var createPin = ""
    var confirmPin = ""
    var hasEnteredPin = false
    var hasEnteredConfirmPin = false
    var tag = ""

    private let dataSource = CreatePinDataModel()
    @IBOutlet weak var lbl_title   : UILabel!
    @IBOutlet weak var otpView1 : VPMOTPView!
    @IBOutlet weak var otpView2 : VPMOTPView!
    
    
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        hideKeyboardWhenTappedArround()
        otpView1.delegate = self
        otpView2.delegate = self
        
        otpView1.otpFieldEntrySecureType = true
        otpView1.initializeUI()
        otpView1.changeStateOfTextField()
        
        otpView2.otpFieldEntrySecureType = true
        otpView2.initializeUI()
        otpView2.changeStateOfTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isCreatingPin ?? false {
            self.lbl_title.text = "Create PIN"
        } else {
            self.lbl_title.text = "Enter PIN"
        }
    }
    
    // MARK:- --- Action ----
    
   /* @IBAction func btn_show(_ sender:UIButton) {
        otpView.otpFieldEntrySecureType = !otpView.otpFieldEntrySecureType
        otpView.changeStateOfTextField()
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
            
        }
    }*/

    @IBAction func btn_Submit(_ sender:UIButton) {
        if self.isCreatingPin ?? false {
            if !hasEnteredPin
            {
                self.view.makeToast("Enter passcode", duration: 3, position: .bottom)
            }
            else if !hasEnteredConfirmPin
            {
                self.view.makeToast("Enter confirm passcode", duration: 3, position: .bottom)
            }
            else if(createPin != confirmPin)
            {
                self.view.makeToast("create pin and confirm pin should match", duration: 3, position: .bottom)
            }
            else
            {
                Connection.svprogressHudShow(view: self)
                dataSource.pincode = confirmPin
                dataSource.createPin()
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
            // self.delegate?.isClickedButton()
        }
        
    }
}
extension CreatePinVC:VPMOTPViewDelegate{
    func hasEnteredAllOTP(hasEntered: Bool,tag:Int) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        if tag == 0
        {
            self.hasEnteredPin = hasEntered
        }
        else
        {
            self.hasEnteredConfirmPin = hasEntered
        }
        return hasEntered
    }
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int,tag:Int) -> Bool {
        self.tag = "\(tag)"
        print(index)
        if tag == 0
        {
            if hasEnteredPin && index < 3
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            if hasEnteredConfirmPin && index < 3
            {
                return false
            }
            else
            {
                return true
            }
        }
    }
    func enteredOTP(otpString: String, tag: Int) {
        if tag == 0{
            createPin = otpString
        }
        else{
            confirmPin = otpString
        }
        print("OTPString: \(otpString)")
    }
}

extension CreatePinVC : CreatePinDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.setValue(data.data?.isPin, forKey: "isPin")
            UserDefaults.standard.setPin(value: confirmPin)
            if let vc = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC
            {
                vc.fromPin = true
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
