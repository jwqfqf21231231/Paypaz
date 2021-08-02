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
    func didRecieveDataUpdate(data:SignUpModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class SignUpDataModel: NSObject
{
    weak var delegate: SignUpDataModelDelegate?
    let sharedInstance = Connection()
    var email = ""
    var password = ""
    var phoneNumber = ""
    func requestSignUp()
    {
        let url =  APIList().getUrlString(url: .SIGNUP)
        var deviceToken = String()
        if UserDefaults.standard.value(forKey: "DeviceToken") != nil{
            deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as! String
        }else{
            deviceToken = ""
        }
        let parameter : Parameters = [
            "phoneNumber":phoneNumber,
            "email":email ,
            "phoneCode":UserDefaults.standard.getPhoneCode(),
            "password":password,
            "deviceToken":deviceToken,
            "deviceType":"ios",
            "latitude":UserDefaults.standard.getLatitude(),
            "longitude":UserDefaults.standard.getLongitude(),
            "countryCode":UserDefaults.standard.getCountryCode()
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
                                                let response = try JSONDecoder().decode(SignUpModel.self, from: result!)
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

