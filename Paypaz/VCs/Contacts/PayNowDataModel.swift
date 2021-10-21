//
//  PayNowModel.swift
//  Paypaz
//
//  Created by PARAS on 21/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import Foundation
import Alamofire

protocol PayNowDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class PayNowDataModel: NSObject
{
    weak var delegate: PayNowDelegate?
    let sharedInstance = Connection()
    var receiverID = ""
    var requestID = ""
    var paymentMethod = ""
    var amount = ""
    var cardID = ""
    var pincode = ""
    var cvv = ""
    var phoneNumber = ""
    var phoneCode = ""
    var name = ""
    var dataDescription = ""
    func payNow()
    {
        
        let url =  APIList().getUrlString(url: .PAYNOW)
        
        let parameter : Parameters = [
            "receiverID":receiverID ,
            "requestID":requestID,
            "paymentMethod":paymentMethod,
            "amount":amount,
            "cardID":cardID,
            "pincode":pincode,
            "cvv":cvv,
            "phoneNumber":phoneNumber,
            "phoneCode":phoneCode,
            "name":name,
            "description":dataDescription,
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
                    let response = try JSONDecoder().decode(ResendOTPModel.self, from: result!)
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
