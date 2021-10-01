//
//  GetWalletAmountDataModel.swift
//  Paypaz
//
//  Created by MAC on 27/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire
protocol GetWalletAmountDelegate:class {
    func didRecieveDataUpdate(data:GetWalletAmount)
    func didFailDataUpdateWithError(error:Error)
}
protocol AddMoneyInWalletDelegate : class{
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError1(error:Error)
}
class GetWalletAmountDataModel: NSObject
{
    weak var getWalletAmountDelegate: GetWalletAmountDelegate?
    weak var addMoneyInWalletDelegate : AddMoneyInWalletDelegate?
    let sharedInstance = Connection()
    var cardHolderName = ""
    var cardNumber = ""
    var cvv = ""
    var expDate = ""
    var amount = ""
    var cardID = ""
    var isCard = ""
    func getWalletAmount()
    {
        let url =  APIList().getUrlString(url: .GETWALLETAMOUNT)
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
                                                let response = try JSONDecoder().decode(GetWalletAmount.self, from: result!)
                                                self.getWalletAmountDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.getWalletAmountDelegate?.didFailDataUpdateWithError(error: error)
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
                                        self.getWalletAmountDelegate?.didFailDataUpdateWithError(error: error)
                                    })
    }
    func addMoneyToWallet(){
        let url =  APIList().getUrlString(url: .ADDAMOUNTINWALLET)
        
        let parameter : Parameters = [
            "cardID":cardID,
            "isCard":isCard,
            "cvv" : cvv,
            "amount" : amount
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
                                                self.addMoneyInWalletDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.addMoneyInWalletDelegate?.didFailDataUpdateWithError1(error: error)
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
                                        self.addMoneyInWalletDelegate?.didFailDataUpdateWithError1(error: error)
                                        
                                    })
    }
}
