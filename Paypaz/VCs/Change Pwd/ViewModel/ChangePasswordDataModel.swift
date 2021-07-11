//
//  ChangePasswordDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 30/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol ChangePasswordDataModelDelegate:class {
    func didRecieveDataUpdate(data:ChangePasswordModel)
    func didFailDataUpdateWithError(error:Error)
}

class ChangePasswordDataModel: NSObject
{
    weak var delegate: ChangePasswordDataModelDelegate?
    let sharedInstance = Connection()
    var oldPassword = ""
    var newPassword = ""
    var hideOldPassword : Bool?
    var url:String?
    var parameter : Parameters = [:]
    var headers : HTTPHeaders = [:]
    func requestPasswordChange()
    {
        headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        if self.hideOldPassword ?? false {
            url =  APIList().getUrlString(url: .RESETPASSWORD)
            parameter = [
                "password":newPassword
            ]
        }
        else
        {
            url =  APIList().getUrlString(url: .CHANGEPASSWORD)
            parameter = [
                "oldPassword":oldPassword,
                "newPassword":newPassword
            ]
        }
        sharedInstance.requestPOST(url!, params: parameter, headers: headers,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(ChangePasswordModel.self, from: result!)
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

