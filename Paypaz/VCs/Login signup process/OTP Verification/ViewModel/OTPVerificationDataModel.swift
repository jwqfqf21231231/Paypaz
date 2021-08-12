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
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
}
protocol ForgotPasswordOTPModelDelegate:class {
    func didRecieveDataUpdate1(data:ResendOTPModel)
    func didFailDataUpdateWithError1(error:Error)
}
protocol ResendOTPModelDelegate:class {
    func didRecieveDataUpdate2(data:ResendOTPModel)
    func didFailDataUpdateWithError2(error:Error)
}
protocol ForgotPasscodeVerifyOTPModelDelegate:class {
    func didRecieveDataUpdate3(data:ResendOTPModel)
    func didFailDataUpdateWithError3(error:Error)
}
protocol VerifyChangePasswordModelDelegate:class {
    func didRecieveDataUpdate4(data:LogInModel)
    func didFailDataUpdateWithError4(error:Error)
}

class OTPVerificationDataModel: NSObject
{
    var doForgotPassword : Bool?
    weak var delegate : OTPVerificationDataModelDelegate?
    weak var delegate1 : ForgotPasswordOTPModelDelegate?
    weak var delegate2 : ResendOTPModelDelegate?
    weak var delegate3 : ForgotPasscodeVerifyOTPModelDelegate?
    weak var delegate4 : VerifyChangePasswordModelDelegate?
    let sharedInstance = Connection()
    var url:String?
    var parameter : Parameters = [:]
    var headers : HTTPHeaders = [:]
    var email = ""
    var phoneNumber = ""
    var password = ""
    var otp = ""
    var userTypedOTP = ""
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
                                                    let response = try JSONDecoder().decode(ResendOTPModel.self, from: result!)
                                                    self.delegate1?.didRecieveDataUpdate1(data: response)
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
            url =  APIList().getUrlString(url: .VERIFYOTP)
            parameter = [
                "otp" : otp
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
                                                    let response = try JSONDecoder().decode(LogInModel.self, from: result!)
                                                    
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
        headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestPOST(url!, params: nil, headers: headers,
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
                                                self.delegate2?.didRecieveDataUpdate2(data: response)
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
            "otp" : otp
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
                                                    JSONDecoder().decode(ResendOTPModel.self, from: result!)
                                                self.delegate3?.didRecieveDataUpdate3(data: response)
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
    func doVerifyPhoneNumber()
    {
        url = APIList().getUrlString(url: .VERIFYCHANGEDPHONENUMBER)
        parameter = [
            "phoneNumber" : phoneNumber,
            "phoneCode" : UserDefaults.standard.getPhoneCode(),
            "countryCode" : UserDefaults.standard.getCountryCode(),
            "otp" : otp
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
                                                    JSONDecoder().decode(LogInModel.self, from: result!)
                                                self.delegate4?.didRecieveDataUpdate4(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate4?.didFailDataUpdateWithError4(error: error)
                                            }
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate4?.didFailDataUpdateWithError4(error: error)
                                    })
    }
}

