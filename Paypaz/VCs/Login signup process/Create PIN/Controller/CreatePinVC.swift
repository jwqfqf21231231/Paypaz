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
    var typedPin = ""
    var hasEntered = false
    private let dataSource = CreatePinDataModel()
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var lbl_title   : UILabel!
    
    
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        hideKeyboardWhenTappedArround()
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBackgroundColor = UIColor.white
        otpView.delegate = self
        otpView.shouldRequireCursor = false
        otpView.shouldAllowIntermediateEditing = false
        otpView.initializeUI()
        otpView.otpFieldEntrySecureType = true
        otpView.changeStateOfTextField()
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
        
        if self.isCreatingPin ?? false {
            UserDefaults.standard.setPin(value: typedPin)
            dataSource.pincode = typedPin
            dataSource.createPin()
        } else {
            self.navigationController?.popViewController(animated: true)
            // self.delegate?.isClickedButton()
        }
    }
}
extension CreatePinVC: VPMOTPViewDelegate {
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
        self.typedPin = otpString
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
            if let vc = self.pushToVC("CreditDebitCardVC") as? CreditDebitCardVC
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
