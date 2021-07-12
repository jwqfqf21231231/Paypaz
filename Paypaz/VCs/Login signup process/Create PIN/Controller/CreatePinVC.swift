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
    private let dataSource = CreatePinDataModel()
    // MARK:- ---
    @IBOutlet weak var txt_Field_1 : UITextField!
    @IBOutlet weak var txt_Field_2 : UITextField!
    @IBOutlet weak var txt_Field_3 : UITextField!
    @IBOutlet weak var txt_Field_4 : UITextField!
    @IBOutlet weak var lbl_title   : UILabel!
    
    
    // MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.setDelegates()
        self.actionToTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isCreatingPin ?? false {
            self.lbl_title.text = "Create PIN"
        } else {
            self.lbl_title.text = "Enter PIN"
        }
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
                typedPin += textField.text!
                txt_Field_2.becomeFirstResponder()
            case txt_Field_2:
                typedPin += textField.text!
                txt_Field_3.becomeFirstResponder()
            case txt_Field_3:
                typedPin += textField.text!
                txt_Field_4.becomeFirstResponder()
            case txt_Field_4:
                typedPin += textField.text!
                txt_Field_4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txt_Field_1:
                typedPin.removeLast()
                txt_Field_1.becomeFirstResponder()
            case txt_Field_2:
                typedPin.removeLast()
                txt_Field_1.becomeFirstResponder()
            case txt_Field_3:
                typedPin.removeLast()
                txt_Field_2.becomeFirstResponder()
            case txt_Field_4:
                typedPin.removeLast()
                txt_Field_3.becomeFirstResponder()
            default:
                break
            }
        }
        else {
            
        }
    }
    // MARK:- --- Action ----
    @IBAction func btn_show(_ sender:UIButton) {
        if self.txt_Field_1.isSecureTextEntry == true
        {
            sender.setImage(UIImage(named: "show_eye"), for: .normal)
            sender.setTitle("Show", for: .normal)
            self.txt_Field_1.isSecureTextEntry = false
            self.txt_Field_2.isSecureTextEntry = false
            self.txt_Field_3.isSecureTextEntry = false
            self.txt_Field_4.isSecureTextEntry = false
        }
        else
        {
            sender.setImage(UIImage(named: "password"), for: .normal)
            sender.setTitle("Hide", for: .normal)
            self.txt_Field_1.isSecureTextEntry = true
            self.txt_Field_2.isSecureTextEntry = true
            self.txt_Field_3.isSecureTextEntry = true
            self.txt_Field_4.isSecureTextEntry = true
        }
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if (txt_Field_1.text == "" || txt_Field_2.text == "" || txt_Field_3.text == "" || txt_Field_4.text == "")
        {
            self.showAlert(withMsg: "Please Enter OTP", withOKbtn: true)
        }
        else
        {
            if self.isCreatingPin ?? false {
                UserDefaults.standard.setPin(value: typedPin)
                dataSource.createPin()
            } else {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.isClickedButton()
            }
        }
    }
}
extension CreatePinVC : CreatePinDataModelDelegate
{
    func didRecieveDataUpdate(data: CreatePinModel)
    {
        print("CreatePinModelData = ",data)
        if data.success == 1
        {
            _ = self.pushToVC("CreditDebitCardVC")
            
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
