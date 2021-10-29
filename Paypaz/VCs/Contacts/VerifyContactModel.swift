//
//  VerifyContactModel.swift
//  Paypaz
//
//  Created by MAC on 19/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol VerifyContactDelegate:class {
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol PaymentRequestDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class VerifyContactDataModel: NSObject
{
    weak var delegate: VerifyContactDelegate?
    weak var requestPaymentDelegate : PaymentRequestDelegate?
    let sharedInstance = Connection()
    var phoneNumber = ""
    var phoneCode = ""
    var receiverID = ""
    var name = ""
    var amount = ""
    var dataDescription = ""
    var userToken = ""
    
    func verifyContact()
    {
        let url =  APIList().getUrlString(url: .VERIFYCONTACT)
        let parameter : Parameters = [
            "userToken" : userToken,
            "phoneNumber" : phoneNumber,
            "phoneCode" : phoneCode
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
    func requestPayment(){
        let url =  APIList().getUrlString(url: .REQUESTFORPAYMENT)
        let parameter : Parameters = [
            "receiverID" : receiverID,
            "name" : name,
            "phoneNumber" : phoneNumber,
            "phoneCode" : phoneCode,
            "amount" : amount,
            "description" : dataDescription
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
                                                self.requestPaymentDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.requestPaymentDelegate?.didFailDataUpdateWithError(error: error)
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
                                        self.requestPaymentDelegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
}
