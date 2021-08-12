//
//  CreatePasscodeVC.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CreatePasscodeVC: UIViewController {
    
    
    var setNewPasscode : Bool?
    weak var delegate : PopupDelegate?
    var createPasscode = ""
    var confirmPasscode = ""
    var hasEnteredPasscode = false
    var hasEnteredConfirmPasscode = false
    var tag = ""
    
    // MARK:- ---
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var otpView1 : VPMOTPView!
    @IBOutlet weak var otpView2 : VPMOTPView!
    private let dataSource = ConfirmPasscodeDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedArround()
        otpView1.delegate = self
        otpView2.delegate = self
        dataSource.delegate = self
        
        otpView1.otpFieldEntrySecureType = true
        otpView1.initializeUI()
        otpView1.changeStateOfTextField()
        
        otpView2.otpFieldEntrySecureType = true
        otpView2.initializeUI()
        otpView2.changeStateOfTextField()
    
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
        if !hasEnteredPasscode
        {
            self.view.makeToast("Enter passcode", duration: 3, position: .bottom)
        }
        else if !hasEnteredConfirmPasscode
        {
            self.view.makeToast("Enter confirm passcode", duration: 3, position: .bottom)
        }
        else if(createPasscode != confirmPasscode)
        {
            self.view.makeToast("create passcode and confirm passcode should match", duration: 3, position: .bottom)
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.passcode = confirmPasscode
            dataSource.createPasscode()
        }
    }
    
}

extension CreatePasscodeVC:VPMOTPViewDelegate{
    func hasEnteredAllOTP(hasEntered: Bool,tag:Int) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        if tag == 0
        {
            self.hasEnteredPasscode = hasEntered
        }
        else
        {
            self.hasEnteredConfirmPasscode = hasEntered
        }
        return hasEntered
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int,tag:Int) -> Bool {
        self.tag = "\(tag)"
        print(index)
        if tag == 0
        {
            if hasEnteredPasscode && index < 3
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
            if hasEnteredConfirmPasscode && index < 3
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
            createPasscode = otpString
        }
        else{
            confirmPasscode = otpString
        }
        print("OTPString: \(otpString)")
    }
}
extension CreatePasscodeVC : ConfirmPasscodeDataModelDelegate
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
