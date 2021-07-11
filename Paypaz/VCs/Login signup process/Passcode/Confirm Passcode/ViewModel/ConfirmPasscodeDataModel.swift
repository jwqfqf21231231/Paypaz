//
//  ConfirmPasscodeDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 09/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol ConfirmPasscodeDataModelDelegate:class {
    func didRecieveDataUpdate(data:ConfirmPasscodeModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class ConfirmPasscodeDataModel: NSObject
{
    weak var delegate: ConfirmPasscodeDataModelDelegate?
    let sharedInstance = Connection()
    func createPasscode()
    {
        let url =  APIList().getUrlString(url: .CREATEPASSCODE)
    
        let parameter : Parameters = [
            "passcode" : UserDefaults.standard.getPasscode()
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
                                                let response = try JSONDecoder().decode(ConfirmPasscodeModel.self, from: result!)
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
}

