//
//  ForgotPasswordVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ForgotPasswordVC : CustomViewController {
    
    private let dataSource = ForgotPasswordDataModel()
    @IBOutlet weak var txt_email    : RoundTextField!
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.txt_email.delegate = self
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Submit(_ sender:UIButton) {
        let email = txt_email.text?.trimmingCharacters(in: .whitespaces)
        if email == ""{
            self.showAlert(withMsg: "Please enter your email id", withOKbtn: true)
        }
        else if !(email!.isValidEmail()){
            self.showAlert(withMsg: "Please enter valid email id", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
            dataSource.email = email!
            dataSource.requestForPassword()
        }
    }
    
    @IBAction func btn_backToLogin(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
}
extension ForgotPasswordVC : ForgotPasswordDataModelDelegate
{
    func didRecieveDataUpdate(data: SignUpModel)
    {
        print("ForgotPasswordModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            //UserDefaults.standard.setBearerToken(value: data.data?.token ?? "")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
            vc.email = txt_email.text ?? ""
            vc.doForgotPassword = true
            vc.verifyOTP = data.data?.otp ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
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
