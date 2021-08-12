//
//  EditPhoneNoDataModel.swift
//  Paypaz
//
//  Created by mac on 11/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol EditPhoneNoDataModelDelegate:class {
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol ResendOTPToChangePhoneNo:class {
    func didRecieveDataUpdate5(data:LogInModel)
    func didFailDataUpdateWithError5(error:Error)
}
class EditPhoneNoDataModel: NSObject
{
    weak var delegate : EditPhoneNoDataModelDelegate?
    weak var delegate1 : ResendOTPToChangePhoneNo?
    let sharedInstance = Connection()
    var phoneNumber = ""
    var phoneCode = ""
    func changePhoneNumber()
    {
        let url =  APIList().getUrlString(url: .CHANGEPHONENUMBER)
        let parameter : Parameters = [
            "phoneNumber" : phoneNumber,
            "phoneCode" : phoneCode
        ]
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestPOST(url, params: parameter, headers: header,
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
                                        else
                                        {
                                            print("No Response from server...")
                                        }
                                        
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
    func resendOTP()
    {
        let url =  APIList().getUrlString(url: .CHANGEPHONENUMBER)
        let parameter : Parameters = [
            "phoneNumber" : phoneNumber,
            "phoneCode" : phoneCode
        ]
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestPOST(url, params: parameter, headers: header,
                                   success:
                                    {
                                        (JSON) in
                                        
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(LogInModel.self, from: result!)
                                                self.delegate1?.didRecieveDataUpdate5(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate1?.didFailDataUpdateWithError5(error: error)
                                            }
                                        }
                                        else
                                        {
                                            print("No Response from server...")
                                        }
                                        
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate1?.didFailDataUpdateWithError5(error: error)
                                        
                                    })
    }
    
}
