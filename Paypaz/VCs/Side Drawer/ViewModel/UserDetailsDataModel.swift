//
//  UserDetailsDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol UserDetailsDataModelDelegate:class {
    func didRecieveDataUpdate(data:UserDetailsModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class UserDetailsDataModel: NSObject
{
    weak var delegate: UserDetailsDataModelDelegate?
    let sharedInstance = Connection()
    
    func getUserDetails()
    {
        let url =  APIList().getUrlString(url: .USERDETAILS)
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
                                            let response = try JSONDecoder().decode(UserDetailsModel.self, from: result!)
                                            self.delegate?.didRecieveDataUpdate(data: response)
                                        }
                                        catch let error as NSError
                                        {
                                            self.delegate?.didFailDataUpdateWithError(error: error)
                                        }
                                    }
                                    
                                  }, failure: {
                                    (error) in
                                    self.delegate?.didFailDataUpdateWithError(error: error)
                                    
                                  })
    }
}
