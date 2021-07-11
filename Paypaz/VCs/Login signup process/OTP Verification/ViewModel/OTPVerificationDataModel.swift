//
//  OTPVerificationDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 29/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire
protocol OTPVerificationDataModelDelegate:class {
    func didRecieveDataUpdate(data:OTPVerificationModel)
    func didFailDataUpdateWithError(error:Error)
}
protocol ForgotPasswordOTPModelDelegate:class {
    func didRecieveDataUpdate(data:ForgotPasswordOTPModel)
    func didFailDataUpdateWithError1(error:Error)
}
protocol ResendOTPModelDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError2(error:Error)
}
protocol ForgotPasscodeVerifyOTPModelDelegate:class {
    func didRecieveDataUpdate2(data:ForgotPasswordOTPModel)
    func didFailDataUpdateWithError3(error:Error)
}
class OTPVerificationDataModel: NSObject
{
    var doForgotPassword : Bool?
    weak var delegate : OTPVerificationDataModelDelegate?
    weak var delegate1 : ForgotPasswordOTPModelDelegate?
    weak var delegate2 : ResendOTPModelDelegate?
    weak var delegate3 : ForgotPasscodeVerifyOTPModelDelegate?
    let sharedInstance = Connection()
    var url:String?
    var parameter : Parameters = [:]
    var headers : HTTPHeaders = [:]
    var email = ""
    var password = ""
    var otp = ""
    var userTypedOTP = ""
    //To verify for ForgotPasscodeOTP
    var passcodeOTP = ""
    
    func verifyOTP()
    {
        if self.doForgotPassword ?? false {
            url =  APIList().getUrlString(url: .FORGOTPASSWORDOTP)
            parameter = [
                "otp":otp
            ]
            headers = [
                "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
            ]
            sharedInstance.requestPOST(url!, params: parameter, headers: headers,
                                       success:
                                        {
                                            (JSON) in
                                            let  result :Data? = JSON
                                            if result != nil
                                            {
                                                do
                                                {
                                                    let response = try JSONDecoder().decode(ForgotPasswordOTPModel.self, from: result!)
                                                    self.delegate1?.didRecieveDataUpdate(data: response)
                                                }
                                                catch let error as NSError
                                                {
                                                    self.delegate1?.didFailDataUpdateWithError1(error: error)
                                                }
                                            }
                                        },
                                       failure:
                                        {
                                            (error) in
                                            self.delegate1?.didFailDataUpdateWithError1(error: error)
                                            
                                        })
        }
        else
        {
            var deviceToken = String()
            if UserDefaults.standard.value(forKey: "DeviceToken") != nil{
                deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as! String
            }else{
                deviceToken = ""
            }
            url =  APIList().getUrlString(url: .VERIFYOTP)
            parameter = [
                "emailORphone":email,
                "password":password,
                "deviceToken":deviceToken,
                "deviceType":"iOS",
                "verify":userTypedOTP,
                "latitude":UserDefaults.standard.getLatitude(),
                "longitude":UserDefaults.standard.getLongitude(),
                "otp":otp
            ]
            sharedInstance.requestPOST(url!, params: parameter, headers: nil,
                                       success:
                                        {
                                            (JSON) in
                                            let  result :Data? = JSON
                                            if result != nil
                                            {
                                                do
                                                {
                                                    let response = try JSONDecoder().decode(OTPVerificationModel.self, from: result!)
                                                    
                                                    self.delegate?.didRecieveDataUpdate(data: response)
                                                }
                                                catch let error as NSError
                                                {
                                                    self.delegate?.didFailDataUpdateWithError(error: error)
                                                }
                                            }
                                        },
                                       failure:
                                        {
                                            (error) in
                                            self.delegate?.didFailDataUpdateWithError(error: error)
                                        })
        }
    }
    func resendOTP()
    {
        url = APIList().getUrlString(url: .RESENDOTP)
        parameter = [
            "emailORphone":email
        ]
        
        sharedInstance.requestPOST(url!, params: parameter, headers: nil,
                                   success:
                                    {
                                        (JSON) in
                                        let result : Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try
                                                    JSONDecoder().decode(ResendOTPModel.self, from: result!)
                                                self.delegate2?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate2?.didFailDataUpdateWithError2(error: error)
                                            }
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate2?.didFailDataUpdateWithError2(error: error)
                                    })
    }
    func forgotPasscodeOTPVerify()
    {
        url = APIList().getUrlString(url: .FORGOTPASSWORDOTP)
        parameter = [
            "otp" : passcodeOTP
        ]
        headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestPOST(url!, params: parameter, headers: headers,
                                   success:
                                    {
                                        (JSON) in
                                        let result : Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try
                                                    JSONDecoder().decode(ForgotPasswordOTPModel.self, from: result!)
                                                self.delegate3?.didRecieveDataUpdate2(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate3?.didFailDataUpdateWithError3(error: error)
                                            }
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate3?.didFailDataUpdateWithError3(error: error)
                                    })
    }
}

