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
    func didFailDataUpdateWithError1(error:Error)
    
}
class LogInDataModel: NSObject
{
    weak var delegate: LogInDataModelDelegate?
    let sharedInstance = Connection()
    var phoneCode = ""
    var email = ""
    var password = ""
    var userID = ""
    var deviceID = ""
    func requestLogIn()
    {
        
        let url =  APIList().getUrlString(url: .LOGIN)
    
        let parameter : Parameters = [
            "emailORphone":email ,
            "password":password,
            "phoneCode":phoneCode,
            "latitude":UserDefaults.standard.getLatitude(),
            "longitude":UserDefaults.standard.getLongitude(),
            "deviceType":"ios",
            "deviceToken":UserDefaults.standard.getFireBaseToken(),
            "deviceId": deviceID
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
                                                self.delegate?.didFailDataUpdateWithError1(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError1(error: error)
                                        
                                    })
    }
    func getUserProfile(){
        let url =  APIList().getUrlString(url: .USERPROFILE)
        
        let parameter : Parameters = [
            "userID" : userID
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
                                                self.delegate?.didFailDataUpdateWithError1(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError1(error: error)
                                        
                                    })
    }
    
}
