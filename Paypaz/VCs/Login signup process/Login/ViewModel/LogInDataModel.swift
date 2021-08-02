//
//  LogInDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 29/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol LogInDataModelDelegate:class {
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class LogInDataModel: NSObject
{
    weak var delegate: LogInDataModelDelegate?
    let sharedInstance = Connection()
    var email = ""
    var password = ""
    
    func requestLogIn()
    {
        
        let url =  APIList().getUrlString(url: .LOGIN)
        var deviceToken = String()
        if UserDefaults.standard.value(forKey: "DeviceToken") != nil{
            deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as! String
        }else{
            deviceToken = ""
        }
        let parameter : Parameters = [
            "emailORphone":email ,
            "password":password,
            "phoneCode":UserDefaults.standard.getPhoneCode(),
            "latitude":UserDefaults.standard.getLatitude(),
            "longitude":UserDefaults.standard.getLongitude(),
            "deviceType":"ios",
            "deviceToken":deviceToken
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
                                            print("No Response from server...")
                                        }
                                        
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
    
}
