//
//  DeleteEventDataModel.swift
//  Paypaz
//
//  Created by mac on 19/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol DeleteEventDataModelDelegate:class {
    func didRecieveDataUpdate(data:SignUpModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class DeleteEventDataModel: NSObject
{
    weak var delegate: DeleteEventDataModelDelegate?
    let sharedInstance = Connection()
    var eventID = ""
    func deleteEvent()
    {
        
        var url =  APIList().getUrlString(url: .DELETEEVENT)
        url = url+eventID
        
        sharedInstance.requestDELETE(url, params: nil, headers: nil,
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
