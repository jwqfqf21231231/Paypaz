//
//  PaymentRequestDataModel.swift
//  Paypaz
//
//  Created by MAC on 19/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol UserRequestDelegate:class {
    func didRecieveDataUpdate(data:UserRequestModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class UserRequestDataModel: NSObject
{
    weak var delegate: UserRequestDelegate?
    let sharedInstance = Connection()
    var pageNo = ""
    
    func getPaymentRequests()
    {
        
        let url =  APIList().getUrlString(url: .REQUESTUSERFORPAYMENT)
        let parameter : Parameters = [
            "pageNo" : pageNo
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
                                                let response = try JSONDecoder().decode(UserRequestModel.self, from: result!)
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
