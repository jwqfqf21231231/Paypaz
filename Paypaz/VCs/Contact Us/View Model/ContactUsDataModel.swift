//
//  ContactUsDataModel.swift
//  Paypaz
//
//  Created by mac on 12/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol ContactUsDataModelDelegate:class {
    func didRecieveDataUpdate(data:SuccessModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class ContactUsDataModel: NSObject
{
    weak var delegate: ContactUsDataModelDelegate?
    let sharedInstance = Connection()
    var email = ""
    var subject = ""
    var message = ""
    func contactAdmin()
    {
        let url =  APIList().getUrlString(url: .CONTACTUS)
        
        let parameter : Parameters = [
            "email" : email,
            "subject" : subject,
            "message" : message
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
                                                let response = try JSONDecoder().decode(SuccessModel.self, from: result!)
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
