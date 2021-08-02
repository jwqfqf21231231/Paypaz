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
    var isChecked : Bool = false
    //var location:CLLocation?
    
    @IBOutlet weak var txt_PhoneNo : UITextField!
    @IBOutlet weak var txt_email    : RoundTextField!
    @IBOutlet weak var txt_Password : RoundTextField!
    @IBOutlet weak var txt_ConfirmPassword : RoundTextField!
    @IBOutlet weak var code_btn : UIButton!

    
    //Country Code and Phone Code
    var country_code = "US"
    var phone_code = "+1"
    var textStr = ""
    var phoneNo = ""
    
    private var nbPhoneNumber: NBPhoneNumber?
    private var formatter: NBAsYouTypeFormatter?
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedOutside()
        self.setDelegate()
        self.getLocation()
        updatePlaceholder(country_code)
    }
    private func getLocation()
    {
        //        MARK:- Getting Current Location
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
//        self.txt_ConfirmPassword.delegate = self
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
            UserDefaults.standard.setPhoneCode(value: dial_code)
            UserDefaults.standard.setCountryCode(value: code)
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
        return phoneNumber.replacingOccurrences(of: "\(dialCode) ", with: "").replacingOccurrences(of:phone_code, with: "")
    }
    @IBAction func btn_SignIn(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_Signup(_ sender:UIButton) {
        let email = txt_email.text?.trimmingCharacters(in: .whitespaces)
        let password = txt_Password.text?.trimmingCharacters(in: .whitespaces)
        let confPassword = txt_ConfirmPassword.text?.trimmingCharacters(in: .whitespaces)
        if email == ""{
            self.showAlertPopup(withMsg: "Please enter your email id", withOKbtn: true)
        }
        else if !(email!.isValidEmail()){
            self.showAlertPopup(withMsg: "Please Enter valid Email ID", withOKbtn: true)
        }
        else if txt_PhoneNo.text == ""
        {
            self.showAlertPopup(withMsg: "Please enter your mobile No", withOKbtn: true)
        }
        else if password == ""{
            self.showAlertPopup(withMsg: "please enter password", withOKbtn: true)
        }
        
        else if confPassword == ""{
            self.showAlertPopup(withMsg: "Please enter confirm password", withOKbtn: true)
        }
        else if password != confPassword
        {
            self.showAlertPopup(withMsg: "Password and confirm Password must match", withOKbtn: true)
        }
        else if isChecked == false
        {
            self.showAlertPopup(withMsg: "Please agree Terms and Conditions", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.phoneNumber = txt_PhoneNo.text ?? ""
            dataSource.email = email!
            dataSource.password = password!
            dataSource.requestSignUp()
        }
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsPoliciesVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension SignupVC : SignUpDataModelDelegate
{
    func didRecieveDataUpdate(data: SignUpModel)
    {
        print("SignUpModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.setEmail(value: txt_email.text ?? "")
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
            viewController.email = data.data?.emailORphone ?? ""
            viewController.password = data.data?.password ?? ""
            viewController.verifyOTP = data.data?.otp ?? ""
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else
        {
            self.showAlertPopup(withMsg: data.messages ?? "", withOKbtn: true)
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
extension SignupVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField.tag == 1{
                self.formatter?.clear()
            }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 1{
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
            }
            return false
        }
        else{
            return true
        }
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



