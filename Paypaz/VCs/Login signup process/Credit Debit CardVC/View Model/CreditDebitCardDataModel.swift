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
class CreateCardDataModel: NSObject
{
    weak var delegate : CreateCardDataModelDelegate?
    weak var delegate1 : BankInfoDataModelDelegate?
    let sharedInstance = Connection()
    
    var bankName = ""
    var cardNumber = ""
    var expDate = ""
    var cardHolderName = ""
    var cvv = ""
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
            "bankName" : bankName,
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
}

