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
    private let dataSource = PasscodeDataModel()
    // MARK:- ---
    @IBOutlet weak var txt_Field_1 : UITextField!
    @IBOutlet weak var txt_Field_2 : UITextField!
    @IBOutlet weak var txt_Field_3 : UITextField!
    @IBOutlet weak var txt_Field_4 : UITextField!
    
    var isNavigatedFromPaymentVC : Bool?
    
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource.delegate2 = self
        hideKeyboardWhenTappedArround()
        self.setDelegates()
        self.actionToTextFields()
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
                typedPasscode += textField.text!
                txt_Field_2.becomeFirstResponder()
            case txt_Field_2:
                typedPasscode += textField.text!
                txt_Field_3.becomeFirstResponder()
            case txt_Field_3:
                typedPasscode += textField.text!
                txt_Field_4.becomeFirstResponder()
            case txt_Field_4:
                typedPasscode += textField.text!
                txt_Field_4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txt_Field_1:
                typedPasscode.removeLast()
                txt_Field_1.becomeFirstResponder()
            case txt_Field_2:
                typedPasscode.removeLast()
                txt_Field_1.becomeFirstResponder()
            case txt_Field_3:
                typedPasscode.removeLast()
                txt_Field_2.becomeFirstResponder()
            case txt_Field_4:
                typedPasscode.removeLast()
                txt_Field_3.becomeFirstResponder()
            default:
                break
            }
        }
        else {
            
        }
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
extension PasscodeVC : PasscodeDataModelDelegate
{
    
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            _ = self.pushToVC("SideDrawerBaseVC")
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
            if let OTPVerificationVC = self.pushToVC("OTPVerificationVC") as? OTPVerificationVC{
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
