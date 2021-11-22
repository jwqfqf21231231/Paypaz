//
//  LogOutDataModel.swift
//  Paypaz
//
//  Created by mac on 11/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol LogOutDataModelDelegate:class {
    func didRecieveDataUpdate1(data:ResendOTPModel)
    func didFailDataUpdateWithError3(error:Error)
    
}
class LogOutDataModel: NSObject
{
    weak var delegate: LogOutDataModelDelegate?
    let sharedInstance = Connection()
    
    func loggingOUt()
    {
        let url =  APIList().getUrlString(url: .LOGOUT)
        let header:HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestGET(url, params: nil, headers: header,
                                  success: {
                                    (JSON) in
                                    let  result :Data? = JSON
                                    if result != nil
                                    {
                                        do
                                        {
                                            let response = try JSONDecoder().decode(ResendOTPModel.self, from: result!)
                                            self.delegate?.didRecieveDataUpdate1(data: response)
                                        }
                                        catch let error as NSError
                                        {
                                            self.delegate?.didFailDataUpdateWithError3(error: error)
                                        }
                                    }
                                    
                                  }, failure: {
                                    (error) in
                                    self.delegate?.didFailDataUpdateWithError3(error: error)
                                    
                                  })
    }
}
