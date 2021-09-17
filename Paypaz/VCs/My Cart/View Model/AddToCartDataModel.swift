//
//  AddToCartDataModel.swift
//  Paypaz
//
//  Created by MAC on 16/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol AddToCartDataModelDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError1(error:Error)
    
}
class AddToCartDataModel: NSObject
{
    weak var delegate: AddToCartDataModelDelegate?
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
    var addedDate = ""
    var products:NSString = ""
    func addToCart()
    {
        
        let url =  APIList().getUrlString(url: .ADDTOCART)
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
            "addedDate" : addedDate,
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
                                                let response = try JSONDecoder().decode(ResendOTPModel.self, from: result!)
                                                self.delegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate?.didFailDataUpdateWithError1(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError1(error: error)
                                        
                                    })
    }
}
