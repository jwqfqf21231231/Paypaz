//
//  PasscodeOTPDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 07/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol PasscodeDataModelDelegate:class {
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol ForgotPasscodeDataModelDelegate:class {
    func didRecieveDataUpdate(data:ForgotPasscodeModel)
    func didFailDataUpdateWithError2(error:Error)
    
}
class PasscodeDataModel: NSObject
{
    weak var delegate : PasscodeDataModelDelegate?
    weak var delegate2 : ForgotPasscodeDataModelDelegate?
    let sharedInstance = Connection()
    var passcode = ""
    func validatePasscode()
    {
        let url =  APIList().getUrlString(url: .PASSCODE)
        let parameter : Parameters = [
            "passcode":passcode,
            "latitude":UserDefaults.standard.getLatitude(),
            "longitude":UserDefaults.standard.getLongitude()
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
                                            print("No response from server")
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
    func getOTP()
    {
        let url =  APIList().getUrlString(url: .FORGOTPASSCODEOTP)
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestPOST(url, params: nil, headers: header,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(ForgotPasscodeModel.self, from: result!)
                                                self.delegate2?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate2?.didFailDataUpdateWithError2(error: error)
                                            }
                                        }
                                        else
                                        {
                                            print("No response from server")
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate2?.didFailDataUpdateWithError2(error: error)
                                        
                                    })
    }
}
