//
//  SignupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import CoreLocation

class SignupVC : CustomViewController {
    
    private let dataSource = SignUpDataModel()
    var isChecked : Bool = false
    //var location:CLLocation?
    
    @IBOutlet weak var txt_email    : RoundTextField!
    @IBOutlet weak var txt_Password : RoundTextField!
    @IBOutlet weak var txt_ConfirmPassword : RoundTextField!
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        self.setDelegate()
        self.getLocation()
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
        self.txt_email.delegate    = self
        self.txt_Password.delegate = self
        self.txt_ConfirmPassword.delegate = self
    }
    
    
    // MARK: ---- Action ----
    @IBAction func btn_SignIn(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_Signup(_ sender:UIButton) {
        let email = txt_email.text?.trimmingCharacters(in: .whitespaces)
        let password = txt_Password.text?.trimmingCharacters(in: .whitespaces)
        let confPassword = txt_ConfirmPassword.text?.trimmingCharacters(in: .whitespaces)
        if email == ""{
            self.showAlert(withMsg: "Please enter your email id", withOKbtn: true)
        }
//        else if !(email!.isValidEmail()){
//            self.showAlert(withMsg: "Please Enter valid Email ID", withOKbtn: true)
//        }
        else if password == ""{
            self.showAlert(withMsg: "please enter password", withOKbtn: true)
        }
        
        else if confPassword == ""{
            self.showAlert(withMsg: "Please enter confirm password", withOKbtn: true)
        }
        else if password != confPassword
        {
            self.showAlert(withMsg: "Password and confirm Password must match", withOKbtn: true)
        }
        else if isChecked == false
        {
            self.showAlert(withMsg: "Please agree Terms and Conditions", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
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
          _ = self.pushToVC("TermsPoliciesVC")
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
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
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


