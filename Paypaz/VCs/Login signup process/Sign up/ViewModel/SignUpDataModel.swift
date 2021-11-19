//
//  SignUpDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 28/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol SignUpDataModelDelegate:class {
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class SignUpDataModel: NSObject
{
    weak var delegate: SignUpDataModelDelegate?
    let sharedInstance = Connection()
    var phoneCode = ""
    var email = ""
    var password = ""
    var phoneNumber = ""
    var deviceId = ""
    func requestSignUp()
    {
        let url =  APIList().getUrlString(url: .SIGNUP)
       
        let parameter : Parameters = [
            "phoneNumber":phoneNumber,
            "email":email ,
            "phoneCode":phoneCode,
            "password":password,
            "deviceToken":UserDefaults.standard.getFireBaseToken(),
            "deviceType":"ios",
            "latitude":UserDefaults.standard.getLatitude(),
            "longitude":UserDefaults.standard.getLongitude(),
            "countryCode":UserDefaults.standard.getCountryCode(),
            "deviceId": deviceId
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
}

