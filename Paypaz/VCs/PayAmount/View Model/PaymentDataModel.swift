//
//  PaymentDataModel.swift
//  Paypaz
//
//  Created by MAC on 07/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol PaymentDelegate:class {
    func didRecieveDataUpdate1(data:Basic_Model)
    func didFailDataUpdateWithError(error:Error)
}

class PaymentDataModel: NSObject
{
    weak var delegate: PaymentDelegate?
    let sharedInstance = Connection()
    var eventID = ""
    var eventUserID = ""
    var eventQty = ""
    var eventPrice = ""
    var productsPrice = ""
    var subTotal = ""
    var discount = ""
    var tax = ""
    var grandTotal = ""
    var cartID = ""
    var cardID = ""
    var paymentMethod = ""
    var cvv = ""
    var paymentType = ""
    var products:NSString = ""


    func requestPayment()
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        var currentDate = dateformatter.string(from: Date())
        currentDate = currentDate.localToUTC(incomingFormat: "yyyy-MM-dd HH:mm", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
        let url =  APIList().getUrlString(url: .CARTCHECKOUT)
        let parameter : Parameters = [
            "eventID" : eventID,
            "eventUserID" : eventUserID,
            "eventQty" : eventQty,
            "eventPrice" : eventPrice,
            "productsPrice" : productsPrice,
            "subTotal" : subTotal,
            "discount" : discount,
            "tax" : tax,
            "grandTotal" : grandTotal,
            "cartID" : cartID,
            "cardID" : cardID,
            "paymentMethod" : paymentMethod,
            "cvv" : cvv,
            "paymentType" : paymentType,
            "addedDate" : currentDate,
            "products" : products
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
                                                let response = try JSONDecoder().decode(Basic_Model.self, from: result!)
                                                self.delegate?.didRecieveDataUpdate1(data: response)
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
