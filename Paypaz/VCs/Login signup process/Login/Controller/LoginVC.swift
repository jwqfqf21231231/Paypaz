//
//  LoginVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import CoreLocation
import libPhoneNumber_iOS

class LoginVC : UIViewController {
    
    private let dataSource = LogInDataModel()
    @IBOutlet weak var txt_PhoneNo : RoundTextField!
    @IBOutlet weak var txt_email    : RoundTextField!
    @IBOutlet weak var txt_Password : RoundTextField!
    @IBOutlet weak var code_btn : UIButton!
    
    //Country Code and Phone Code
    var country_code = "IN"
    var phone_code = "+91"
    var textStr = ""
    var phoneNo = ""
    var status = false
    var userAccepted : Bool?
    var placeHolderText = ""
    private var nbPhoneNumber: NBPhoneNumber?
    private var formatter: NBAsYouTypeFormatter?
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    // var location:CLLocation?
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
    }
    
    // MARK: - --- Action ----
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
        return phoneNumber.replacingOccurrences(of: "\(dialCode) ", with: "").replacingOccurrences(of: phone_code, with: "")
    }
    @IBAction func btn_Login(_ sender:UIButton) {
        UserDefaults.standard.setPhoneCode(value: phone_code)
        UserDefaults.standard.setCountryCode(value: country_code)
        if validateFields() == true
        {
            Connection.svprogressHudShow(view: self)
            if txt_email.text?.trim().count == 0
            {
                dataSource.email = txt_PhoneNo.text?.removingWhitespaceAndNewlines() ?? ""
            }
            else
            {
                dataSource.email = txt_email.text ?? ""
            }
            dataSource.password = txt_Password.text ?? ""
            dataSource.requestLogIn()
        }
    }
    func validateFields() -> Bool
    {
        view.endEditing(true)
        if txt_email.text?.trim().count == 0 && txt_PhoneNo.text?.trim().count == 0
        {
            view.makeToast("Please Enter Either Email ID or Phone Number")
        }
        else if txt_PhoneNo.text?.trim().count != 0 && txt_PhoneNo.text?.removingWhitespaceAndNewlines().count != placeHolderText.count
        {
            view.makeToast("Please Enter Valid Phone Number")
        }
        else if txt_email.text?.trim().count != 0 && Helper.isEmailValid(email: txt_email.text!) == false
        {
            view.makeToast("Please Enter Valid Email ID")
        }
        else if txt_Password.text?.trim().count == 0
        {
            view.makeToast("Please Enter Password")
        }
        else
        {
            return true
        }
        return false
    }
    @IBAction func btn_Eye(_ sender:UIButton)
    {
        self.txt_Password.isSecureTextEntry = !txt_Password.isSecureTextEntry
        if(txt_Password.isSecureTextEntry)
        {
            sender.setImage(UIImage(named: "password"), for: .normal)
        }
        else
        {
            sender.setImage(UIImage(named: "show_eye"), for: .normal)
        }
    }
    @IBAction func btn_Signup(_ sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btn_ForgotPwd(_ sender:UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension LoginVC : LogInDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.setLoggedIn(value: true)
            UserDefaults.standard.setRegisterToken(value: (data.data?.token ?? ""))
            UserDefaults.standard.setPasscode(value: data.data?.passcode ?? "")
            UserDefaults.standard.setEmail(value: data.data?.email ?? "")
            UserDefaults.standard.setPhoneNo(value: data.data?.phoneNumber ?? "")
            UserDefaults.standard.setValue(data.data?.isNotification, forKey: "isNotification")
            UserDefaults.standard.setValue(data.data?.isPasscode, forKey: "isPasscode")
            UserDefaults.standard.setValue(data.data?.isPin, forKey: "isPin")
            UserDefaults.standard.setValue(data.data?.isProfile, forKey: "isProfile")
            UserDefaults.standard.setValue(data.data?.isVerify, forKey: "isVerify")
            UserDefaults.standard.setValue(data.data?.isVerifyCard, forKey: "isVerifyCard")
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeVC") as! PasscodeVC
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else
        {
            view.makeToast(data.message ?? "")
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
extension LoginVC : UITextFieldDelegate
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
        if let field = textField as? RoundTextField
        {
            if field.tag == 1{
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
            else{
                return true
            }
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
