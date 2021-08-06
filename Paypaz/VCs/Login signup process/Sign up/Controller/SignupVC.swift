//
//  SignupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import CoreLocation
import libPhoneNumber_iOS

class SignupVC : UIViewController {
    
    private let dataSource = SignUpDataModel()
    var isChecked = false
    
    @IBOutlet weak var txt_PhoneNo : RoundTextField!
    @IBOutlet weak var txt_email    : RoundTextField!
    @IBOutlet weak var txt_Password : RoundTextField!
    @IBOutlet weak var txt_ConfirmPassword : RoundTextField!
    @IBOutlet weak var code_btn : UIButton!
    
    
    //Country Code and Phone Code
    var country_code = "IN"
    var phone_code = "+91"
    var textStr = ""
    var phoneNo = ""
    var placeHolderText = ""
    
    private var nbPhoneNumber: NBPhoneNumber?
    private var formatter: NBAsYouTypeFormatter?
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        hideKeyboardWhenTappedArround()
        self.setDelegate()
        updatePlaceholder(country_code)
    }
    private func setDelegate(){
        self.txt_PhoneNo.delegate = self
        self.txt_email.delegate    = self
        self.txt_Password.delegate = self
        self.txt_ConfirmPassword.delegate = self
    }
    
    
    // MARK: ---- Action ----
    @IBAction func selectPhoneNoCode()
    {
        guard let  listVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryListTable") as? CountryListTable else { return }
        listVC.countryID = {[weak self] (dial_code,name,code) in
            guard  let self = self else {
                return
            }
            self.country_code = code
            self.phone_code = dial_code
            self.code_btn.setTitle(dial_code, for: .normal)
            self.code_btn.setImage(UIImage.init(named: code), for: .normal)
            self.code_btn.imageView?.contentMode = .scaleAspectFill
            self.code_btn.imageView?.layer.cornerRadius = 2
            self.updatePlaceholder(code)
            self.txt_PhoneNo.text?.removeAll()
            self.textStr.removeAll()
        }
        self.present(listVC, animated: true, completion: nil)
        
    }
    func updatePlaceholder(_ code:String) {
        UserDefaults.standard.setPhoneCode(value: phone_code)
        UserDefaults.standard.setCountryCode(value: country_code)
        do {
            formatter = NBAsYouTypeFormatter(regionCode: code)
            let example = try phoneUtil.getExampleNumber(code)
            let phoneNumber = "+\(example.countryCode.stringValue)\(example.nationalNumber.stringValue)"
            if let inputString = formatter?.inputString(phoneNumber) {
                txt_PhoneNo.placeholder = remove(dialCode: "+\(example.countryCode.stringValue)", in: inputString)
            } else {
                
            }
        } catch _ {
            
        }
        placeHolderText = txt_PhoneNo.placeholder?.stringByRemovingAll(characters: ["-"," "]) ?? ""
    }
    private func remove(dialCode: String, in phoneNumber: String) -> String {
        return phoneNumber.replacingOccurrences(of: "\(dialCode) ", with: "").replacingOccurrences(of:phone_code, with: "")
    }
    @IBAction func btn_SignIn(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_Signup(_ sender:UIButton) {
        if validateFields() == true
        {
            Connection.svprogressHudShow(view: self)
            dataSource.phoneNumber = txt_PhoneNo.text ?? ""
            dataSource.email = txt_email.text ?? ""
            dataSource.password = txt_Password.text ?? ""
            dataSource.requestSignUp()
        }
        
    }
    func validateFields() -> Bool
    {
        view.endEditing(true)
        if txt_PhoneNo.text?.trim().count == 0
        {
            view.makeToast("Please Enter Your Mobile No")
        }
        else if txt_PhoneNo.text?.trim().count != 0 && txt_PhoneNo.text?.removingWhitespaceAndNewlines().count != placeHolderText.count
        {
            view.makeToast("Please Enter Valid Phone Number")
        }
        else if Helper.isEmailValid(email: txt_email.text!) == false{
            view.makeToast("Please Enter valid Email ID")
        }
        else if txt_Password.text?.trim().count == 0
        {
            view.makeToast("please enter password")
        }
        else if Helper.validatePassword(passwordString: (txt_Password.text!.trim())) == false
        {
            view.makeToast("Password must be a minimum of 8 characters and include a capital letter, numerical digit and special character.")
        }
        else if txt_ConfirmPassword.text?.trim().count == 0
        {
            view.makeToast("Please enter confirm password")
        }
        else if txt_Password.text != txt_ConfirmPassword.text
        {
            view.makeToast("Password and confirm Password must match")
        }
        else if isChecked == false
        {
            view.makeToast("Please agree Terms and Conditions")
        }
        else
        {
            return true
        }
        return false
    }
    @IBAction func btn_Eye(_ sender:UIButton)
    {
        switch sender.tag {
        case 101:
            self.txt_Password.isSecureTextEntry = !txt_Password.isSecureTextEntry
            if(txt_Password.isSecureTextEntry)
            {
                sender.setImage(UIImage(named: "password"), for: .normal)
            }
            else
            {
                sender.setImage(UIImage(named: "show_eye"), for: .normal)
            }
        default:
            self.txt_ConfirmPassword.isSecureTextEntry = !txt_ConfirmPassword.isSecureTextEntry
            if(txt_ConfirmPassword.isSecureTextEntry)
            {
                sender.setImage(UIImage(named: "password"), for: .normal)
            }
            else
            {
                sender.setImage(UIImage(named: "show_eye"), for: .normal)
            }
        }
    }
    @IBAction func btn_Check(_ sender:UIButton)
    {
        isChecked = !isChecked
        if(isChecked)
        {
            sender.setImage(UIImage(named: "accept"), for: .normal)
        }
        else
        {
            sender.setImage(UIImage(named: ""), for: .normal)
        }
    }
    @IBAction func btn_Terms_Conditions(_ sender:UIButton)
    {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TermsPoliciesVC") as? TermsPoliciesVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else{ return }
    }
    
}
extension SignupVC : SignUpDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.setRegisterToken(value: data.data?.token ?? "")
            UserDefaults.standard.setEmail(value: txt_email.text ?? "")
            UserDefaults.standard.setPhoneNo(value: txt_PhoneNo.text ?? "")
            UserDefaults.standard.setPhoneCode(value: "+\(data.data?.phoneCode ?? "")")
            UserDefaults.standard.setCountryCode(value: data.data?.countryCode ?? "")
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
            self.navigationController?.pushViewController(viewController, animated: false)
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
extension SignupVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField
        {
            field.border_Color = UIColor(named: "SkyblueColor")
            if field.tag == 1{
                self.formatter?.clear()
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField
        {
            field.border_Color = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
        }
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 1{
            if string == ""{
                if self.textStr.count > 0{
                    self.textStr.removeLast()
                    didEditText(textStr)
                }
            }
            else{
                if self.textStr.count < placeHolderText.count {
                    self.textStr = self.textStr + string
                    didEditText(textStr)
                }
            }
            return false
        }
        return true
    }
    @objc private func didEditText(_ string:String) {
        var cleanedPhoneNumber = clean(string: "\(String(describing:self.phone_code)) \(string)")
        if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
            nbPhoneNumber = validPhoneNumber
            cleanedPhoneNumber = "+\(validPhoneNumber.countryCode.stringValue)\(validPhoneNumber.nationalNumber.stringValue)"
            if let inputString = formatter?.inputString(cleanedPhoneNumber) {
                txt_PhoneNo.text = remove(dialCode:self.phone_code, in: inputString)
            }
        } else {
            nbPhoneNumber = nil
            if let inputString = formatter?.inputString(cleanedPhoneNumber) {
                txt_PhoneNo.text = remove(dialCode: country_code, in: inputString)
            }
        }
    }
    private func clean(string: String) -> String {
        var allowedCharactersSet = CharacterSet.decimalDigits
        allowedCharactersSet.insert("+")
        return string.components(separatedBy: allowedCharactersSet.inverted).joined(separator: "")
    }
    private func getValidNumber(phoneNumber: String) -> NBPhoneNumber? {
        do {
            let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion:self.phone_code)
            let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)
            return isValid ? parsedPhoneNumber : nil
        } catch _ {
            return nil
        }
    }
}



