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
    func didRecieveDataUpdate(data:ForgotPasswordModel)
    func didFailDataUpdateWithError(error:Error)
}

class ForgotPasswordDataModel: NSObject
{
    weak var delegate: ForgotPasswordDataModelDelegate?
    let sharedInstance = Connection()
    var email = ""
    
    func requestForPassword()
    {
        let url =  APIList().getUrlString(url: .FORGOTPASSWORD)
        let parameter : Parameters = [
            "emailORphone":email
        ]
        sharedInstance.requestPOST(url, params: parameter, headers: nil,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(ForgotPasswordModel.self, from: result!)
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

