//
//  EditPhoneNoVC.swift
//  Paypaz
//
//  Created by mac on 10/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

class EditPhoneNoVC: UIViewController {
    @IBOutlet weak var txt_PhoneNo : RoundTextField!
    
    @IBOutlet weak var code_btn : UIButton!
    //Country Code and Phone Code
    var country_code = "IN"
    var phone_code = "+91"
    var textStr = ""
    var phoneNo = ""
    var placeHolderText = ""
    private let dataSource = EditPhoneNoDataModel()
    private var nbPhoneNumber: NBPhoneNumber?
    private var formatter: NBAsYouTypeFormatter?
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.txt_PhoneNo.delegate = self
        hideKeyboardWhenTappedArround()
        updatePlaceholder(country_code)
    }
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
    @IBAction func btn_Save(_ sender:UIButton) {
        UserDefaults.standard.setPhoneCode(value: phone_code)
        UserDefaults.standard.setCountryCode(value: country_code)
        if txt_PhoneNo.text?.trim().count != 0 && txt_PhoneNo.text?.removingWhitespaceAndNewlines().count != placeHolderText.count
        {
            view.makeToast("Please Enter Valid Phone Number")
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.phoneNumber = txt_PhoneNo.text?.removingWhitespaceAndNewlines() ?? ""
            dataSource.phoneCode = phone_code
            dataSource.changePhoneNumber()
        }
    }
}
extension EditPhoneNoVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField
        {
            field.border_Color = UIColor(named: "SkyblueColor")
            self.formatter?.clear()
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
        if let _ = textField as? RoundTextField
        {
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
extension EditPhoneNoVC : EditPhoneNoDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let vc = self.pushVC("OTPVerificationVC") as? OTPVerificationVC{
                vc.doChangePassword = true
                vc.phoneNumber = txt_PhoneNo.text?.removingWhitespaceAndNewlines() ?? ""
            }
        }
        else
        {
            self.view.makeToast(data.message ?? "")
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
