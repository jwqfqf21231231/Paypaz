//
//  ForgotPasswordDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 30/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol ForgotPasswordDataModelDelegate:class {
    func didRecieveDataUpdate(data:SignUpModel)
    func didFailDataUpdateWithError(error:Error)
}

class ForgotPasswordDataModel: NSObject
{
    weak var delegate: ForgotPasswordDataModelDelegate?
    let sharedInstance = Connection()
    var email = ""
    var phoneCode = ""
    var parameter : Parameters = [:]
    func requestForPassword()
    {
        let url =  APIList().getUrlString(url: .FORGOTPASSWORD)
        if phoneCode == ""
        {
            parameter = [
            "emailORphone":email
            ]
        }
        else
        {
            parameter = [
                "emailORphone":email,
                "phoneCode":phoneCode
            ]
        }
      
        sharedInstance.requestPOST(url, params: parameter, headers: nil,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(SignUpModel.self, from: result!)
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

