//
//  LoginVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import CoreLocation

class LoginVC : CustomViewController {
    
    private let dataSource = LogInDataModel()
    @IBOutlet weak var txt_email    : RoundTextField!
    @IBOutlet weak var txt_Password : RoundTextField!
    var latitude:String = ""
    var longitude:String = ""
   // var location:CLLocation?
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.setDelegate()
        self.getLocation()
        
    }
    //        MARK:- Getting Current Location
    private func getLocation()
    {
        let instance = LocationManager.shared
        instance.getUserLocation { (lat, long) in
            if lat != nil && long != nil{
                UserDefaults.standard.setLatitude(value: "\(lat ?? 0.0)")
                UserDefaults.standard.setLongitude(value: "\(long ?? 0.0)")
                self.latitude = "\(lat ?? 0.0)"
                self.longitude = "\(long ?? 0.0)"
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
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Login(_ sender:UIButton) {
        let email = txt_email.text?.trimmingCharacters(in: .whitespaces)
        let password = txt_Password.text?.trimmingCharacters(in: .whitespaces)
        if email == ""{
            self.showAlert(withMsg: "Please enter your email id", withOKbtn: true)
        }
//        else if !(email!.isValidEmail()){
//            self.showAlertError(titleStr: "Alert", messageStr: "Please enter valid email id")
//        }
        else if password == ""{
            self.showAlert(withMsg: "please enter password", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
            dataSource.email = email!
            dataSource.password = password!
            dataSource.latitude = latitude
            dataSource.longitude = longitude
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
        _ = self.pushToVC("SignupVC")
    }
    
    @IBAction func btn_ForgotPwd(_ sender:UIButton) {
        _ = self.pushToVC("ForgotPasswordVC")
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
            UserDefaults.standard.setLoggedIn(value: true)
            UserDefaults.standard.setRegisterToken(value: (data.data?.token ?? ""))
            UserDefaults.standard.setPasscode(value: data.data?.passcode ?? "")
            UserDefaults.standard.setEmail(value: data.data?.emailORphone ?? "")
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeVC") as! PasscodeVC
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
