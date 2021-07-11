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
    // MARK:- ---
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var txt_Field_1 : UITextField!
    @IBOutlet weak var txt_Field_2 : UITextField!
    @IBOutlet weak var txt_Field_3 : UITextField!
    @IBOutlet weak var txt_Field_4 : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setDelegates()
        self.actionToTextFields()
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
    @IBAction func btn_Next(_ sender:UIButton) {
        if(txt_Field_1.text?.isEmpty == true || txt_Field_2.text?.isEmpty == true || txt_Field_3.text?.isEmpty == true || txt_Field_4.text?.isEmpty == true)
        {
            self.showAlert(withMsg: "Please enter OTP", withOKbtn: true)
        }
        else
        {
            UserDefaults.standard.setPasscode(value: typedPasscode)
            _ = self.pushToVC("ConfirmPasscodeVC")
        }
    }
    
}

