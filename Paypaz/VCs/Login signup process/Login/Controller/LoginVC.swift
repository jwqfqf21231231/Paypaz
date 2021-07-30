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
    @IBOutlet weak var txt_PhoneNo : UITextField!
    @IBOutlet weak var txt_email    : RoundTextField!
    @IBOutlet weak var txt_Password : RoundTextField!
    @IBOutlet weak var code_btn : UIButton!
    
    //Country Code and Phone Code
    var country_code = "US"
    var phone_code = "+1"
    var textStr = ""
    var phoneNo = ""
    
    private var nbPhoneNumber: NBPhoneNumber?
    private var formatter: NBAsYouTypeFormatter?
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    // var location:CLLocation?
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        self.hideKeyboardWhenTappedOutside()
        self.setDelegate()
        self.getLocation()
        updatePlaceholder(country_code)
        
    }
    //  MARK:- Getting Current Location
    private func getLocation()
    {
        let instance = LocationManager.shared
        instance.getUserLocation { (lat, long) in
            if lat != nil && long != nil{
                UserDefaults.standard.setLatitude(value: "\(lat ?? 0.0)")
                UserDefaults.standard.setLongitude(value: "\(long ?? 0.0)")
                //self.location  = CLLocation.init(latitude: lat ?? 0.0, longitude: long ?? 0.0)
                UserDefaults.standard.synchronize()
                //                if AppSettings.hasLogInApp{
                //                    CurrentLocationAPI()
                //                }
            }
        }
    }
    private func setDelegate(){
        self.txt_PhoneNo.delegate = self
        //        self.txt_email.delegate    = self
        //        self.txt_Password.delegate = self
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
            print(self.country_code)
            print(self.phone_code)
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
        
    }
    private func remove(dialCode: String, in phoneNumber: String) -> String {
        return phoneNumber.replacingOccurrences(of: "\(dialCode) ", with: "").replacingOccurrences(of: phone_code, with: "")
    }
    @IBAction func btn_Login(_ sender:UIButton) {
        let email = txt_email.text?.trimmingCharacters(in: .whitespaces)
        let password = txt_Password.text?.trimmingCharacters(in: .whitespaces)
        if email == ""{
            self.showAlertPopup(withMsg: "Please enter your email id", withOKbtn: true)
        }
        else if !(email!.isValidEmail()){
            self.showAlertPopup(withMsg: "Please enter valid email id", withOKbtn: true)
        }
        else if password == ""{
            self.showAlertPopup(withMsg: "please enter password", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.email = email!
            dataSource.password = password!
            dataSource.requestLogIn()
        }
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
        print("LogInModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            //UserDefaults.standard.setLoggedIn(value: true)
            UserDefaults.standard.setRegisterToken(value: (data.data?.token ?? ""))
            UserDefaults.standard.setPasscode(value: data.data?.passcode ?? "")
            UserDefaults.standard.setEmail(value: data.data?.emailORphone ?? "")
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeVC") as! PasscodeVC
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else
        {
            self.showAlertPopup(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlertPopup(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlertPopup(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
extension LoginVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            
            if field.tag == 1{
                self.formatter?.clear()
            }
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == ""{
            if self.textStr.count > 0{
                self.textStr.removeLast()
            }
        }
        else{
            
            if self.textStr.count < txt_PhoneNo.placeholder?.count ?? 0{
                self.textStr = self.textStr + string
            }
            
        }
        if self.textStr.count < txt_PhoneNo.placeholder?.count ?? 0{
            didEditText(textStr)
            return true
        }
        else
        {
            return false
        }
    }
    @objc private func didEditText(_ string:String) {
        var cleanedPhoneNumber = clean(string: "\(String(describing:phone_code)) \(string)")
        if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
            nbPhoneNumber = validPhoneNumber
            cleanedPhoneNumber = "+\(validPhoneNumber.countryCode.stringValue)\(validPhoneNumber.nationalNumber.stringValue)"
            if let inputString = formatter?.inputString(cleanedPhoneNumber) {
                phoneNo = remove(dialCode: phone_code, in: inputString)
            }
        } else {
            nbPhoneNumber = nil
            if let inputString = formatter?.inputString(cleanedPhoneNumber) {
                phoneNo = remove(dialCode: country_code, in: inputString)
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
            let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: phone_code)
            let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)
            return isValid ? parsedPhoneNumber : nil
        } catch _ {
            return nil
        }
    }
}
