//
//  CreditDebitCardDataModel.swift
//  Paypaz
//
//  Created by mac on 12/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol CreateCardDataModelDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol BankInfoDataModelDelegate:class {
    func didRecieveDataUpdate(data:BankInfoModel)
    func didFailDataUpdateWithError1(error:Error)
    
}
protocol AddBankAccountDataModelDelegate:class {
    func didRecieveDataUpdate2(data:ResendOTPModel)
    func didFailDataUpdateWithError2(error:Error)
}
class CreateCardDataModel: NSObject
{
    weak var delegate : CreateCardDataModelDelegate?
    weak var delegate1 : BankInfoDataModelDelegate?
    weak var delegate2 : AddBankAccountDataModelDelegate?
    let sharedInstance = Connection()
    
    //Properties for Creating Card
    var bankID = ""
    var cardNumber = ""
    var expDate = ""
    var cardHolderName = ""
    var cvv = ""
    
    //Properties for Adding Bank Account
    var accountNumber = ""
    var routingNumber = ""
    var email = ""
    var phone = ""
    
    func getBanks()
    {
        let url =  APIList().getUrlString(url: .BANKINFO)
        sharedInstance.requestGET(url, params: nil, headers: nil,
                                  success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(BankInfoModel.self, from: result!)
                                                self.delegate1?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate1?.didFailDataUpdateWithError1(error: error)
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
                                        self.delegate1?.didFailDataUpdateWithError1(error: error)
                                        
                                    })
        
    }
    func createCard()
    {
        let url =  APIList().getUrlString(url: .CREATECARD)
        
        let parameter : Parameters = [
            "bankID" : bankID,
            "cardNumber" : cardNumber,
            "expDate" : expDate,
            "cardHolderName" : cardHolderName,
            "cvv" : cvv
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
                                            print("No response from server")
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
    func addBankAccount()
    {
        let url =  APIList().getUrlString(url: .ADDBANKACCOUNT)
        
        let parameter : Parameters = [
            "bankID" : bankID,
            "accountNumber" : accountNumber,
            "routingNumber" : routingNumber,
            "email" : email,
            "phone" : phone
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
                                                self.delegate2?.didRecieveDataUpdate2(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate2?.didFailDataUpdateWithError2(error: error)
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
                                        self.delegate2?.didFailDataUpdateWithError2(error: error)
                                        
                                    })
    }
}

