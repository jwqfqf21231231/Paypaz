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
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol BankInfoDataModelDelegate:class {
    func didRecieveDataUpdate(data:BankInfoModel)
    func didFailDataUpdateWithError1(error:Error)
    
}
protocol AddBankAccountDataModelDelegate:class {
    func didRecieveDataUpdate2(data:LogInModel)
    func didFailDataUpdateWithError2(error:Error)
}
protocol GetCardsListDataModelDelegate:class{
    func didRecieveDataUpdate(data:CardsListModel)
    func didFailDataUpdateWithError2(error:Error)
}
protocol DeleteCardDataModelDelegate : class {
    func didRecieveDataUpdate(data:SignUpModel)
    func didFailDataUpdateWithError3(error:Error)
}
protocol CardDetailsDataModelDelegate : class{
    func didRecieveDataUpdate(data:CardDetailsModel)
    func didFailDataUpdateWithError(error:Error)
}
protocol UpdateCardDetailDataModelDelegate : class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError2(error:Error)
}
class CreateCardDataModel: NSObject
{
    weak var delegate  : CreateCardDataModelDelegate?
    weak var delegate1 : BankInfoDataModelDelegate?
    weak var delegate2 : AddBankAccountDataModelDelegate?
    weak var cardListDelegate : GetCardsListDataModelDelegate?
    weak var deleteCardDelegate : DeleteCardDataModelDelegate?
    weak var cardDetailsDelegate : CardDetailsDataModelDelegate?
    weak var updateCardDetailsDelegate : UpdateCardDetailDataModelDelegate?
    let sharedInstance = Connection()
    
    //Properties for Creating Card
    var bankID = ""
    var cardNumber = ""
    var expDate = ""
    var cardHolderName = ""
    var cvv = ""
    var status = ""
    var cardName = ""
    var cardID = ""
    
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
            "cardNumber" : cardNumber,
            "expDate" : expDate,
            "cardHolderName" : cardHolderName,
            "cvv" : cvv,
            "cardName" : cardName,
            "status" : status
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
                                            print("No response from server")
                                        }
                                    },
                                   failure:
                                    {
                                        (error) in
                                        self.delegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
    
    func updateCard()
    {
        let url =  APIList().getUrlString(url: .UPDATECARD)
        
        let parameter : Parameters = [
            "cardNumber" : cardNumber,
            "expDate" : expDate,
            "cardHolderName" : cardHolderName,
            "cvv" : cvv,
            "cardName" : cardName,
            "status" : status,
            "cardID" : cardID
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
                                                self.updateCardDetailsDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.updateCardDetailsDelegate?.didFailDataUpdateWithError2(error: error)
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
                                        self.updateCardDetailsDelegate?.didFailDataUpdateWithError2(error: error)
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
                                                let response = try JSONDecoder().decode(LogInModel.self, from: result!)
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
    
    func getCardDetails()
    {
        let url =  APIList().getUrlString(url: .CARDDETAIL)
        let parameter : Parameters = [
            "cardID" : cardID
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
                                                let response = try JSONDecoder().decode(CardDetailsModel.self, from: result!)
                                                self.cardDetailsDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.cardDetailsDelegate?.didFailDataUpdateWithError(error: error)
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
                                        self.cardDetailsDelegate?.didFailDataUpdateWithError(error: error)
                                    })
    }
    func getCardsList()
    {
        let url =  APIList().getUrlString(url: .CARDLIST)
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestGET(url, params: nil, headers: header,
                                  success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(CardsListModel.self, from: result!)
                                                self.cardListDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.cardListDelegate?.didFailDataUpdateWithError2(error: error)
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
                                        self.cardListDelegate?.didFailDataUpdateWithError2(error: error)
                                    })
    }
    
    func deleteCard()
    {
        
        var url =  APIList().getUrlString(url: .DELETECARD)
        url = url+cardID
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.requestDELETE(url, params: nil, headers: header,
                                     success:
                                        {
                                            (JSON) in
                                            let  result :Data? = JSON
                                            if result != nil
                                            {
                                                do
                                            {
                                                let response = try JSONDecoder().decode(SignUpModel.self, from: result!)
                                                self.deleteCardDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                                catch let error as NSError
                                                {
                                                    self.deleteCardDelegate?.didFailDataUpdateWithError3(error: error)
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
                                            self.deleteCardDelegate?.didFailDataUpdateWithError3(error: error)
                                            
                                        })
    }
}

