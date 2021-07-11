//
//  CreatePinDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 09/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol CreatePinDataModelDelegate:class {
    func didRecieveDataUpdate(data:CreatePinModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class CreatePinDataModel: NSObject
{
    weak var delegate: CreatePinDataModelDelegate?
    let sharedInstance = Connection()
    func createPin()
    {
        let url =  APIList().getUrlString(url: .CREATEPIN)
    
        let parameter : Parameters = [
            "pincode" : UserDefaults.standard.getPin()
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
                                                let response = try JSONDecoder().decode(CreatePinModel.self, from: result!)
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
