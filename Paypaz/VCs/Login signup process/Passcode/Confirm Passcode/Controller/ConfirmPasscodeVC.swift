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
    private let dataSource = ConfirmPasscodeDataModel()
    // MARK:- ---
    @IBOutlet weak var txt_Field_1 : UITextField!
    @IBOutlet weak var txt_Field_2 : UITextField!
    @IBOutlet weak var txt_Field_3 : UITextField!
    @IBOutlet weak var txt_Field_4 : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        //        self.hideKeyboardWhenTappedAround()
        self.setDelegates()
        self.actionToTextFields()
        // Do any additional setup after loading the view.
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
    @IBAction func btn_Submit(_ sender:UIButton) {
        if(txt_Field_1.text?.isEmpty == true || txt_Field_2.text?.isEmpty == true || txt_Field_3.text?.isEmpty == true || txt_Field_4.text?.isEmpty == true)
        {
            self.showAlert(withMsg: "Please enter Confirm Passcode", withOKbtn: true)
        }
        else
        {
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
                _ = self.pushToVC("SideDrawerBaseVC")
            }
            else
            {
                if let createVc = self.pushToVC("CreatePinVC") as? CreatePinVC{
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
