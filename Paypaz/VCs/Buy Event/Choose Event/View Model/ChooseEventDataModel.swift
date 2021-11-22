//
//  ChooseEventDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 06/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol ChooseEventDataModelDelegate:class {
    func didRecieveDataUpdate(data:ChooseEventModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class ChooseEventDataModel: NSObject
{
    weak var delegate: ChooseEventDataModelDelegate?
    let sharedInstance = Connection()
    func getEventTypes()
    {
        let url =  APIList().getUrlString(url: .EVENTTYPES)
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestGET(url,
                                  params: nil,
                                  headers: header,
                                  success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(ChooseEventModel.self, from: result!)
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
