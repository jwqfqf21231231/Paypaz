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
protocol GetCartItemsDataModelDelegate:class {
    func didRecieveDataUpdate(data:CartItemsModel)
    func didFailDataUpdateWithError5(error:Error)
}
protocol GetCartDetailsDataModelDelegate:class {
    func didRecieveDataUpdate(data:CartDetailsModel)
    func didFailDataUpdateWithError3(error:Error)
}
protocol CartCheckOutDataModelDelegate:class {
    func didRecieveDataUpdate1(data:ResendOTPModel)
    func didFailDataUpdateWithError4(error:Error)
}
class AddToCartDataModel: NSObject
{
    weak var delegate: AddToCartDataModelDelegate?
    weak var cartItemsDelegate : GetCartItemsDataModelDelegate?
    weak var cartDetailsDelegate : GetCartDetailsDataModelDelegate?
    weak var cartCheckOutDelegate : CartCheckOutDataModelDelegate?
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
    
    //Check Out
    var cardID = ""
    var paymentMethod = ""
    var cvv = ""
    var paymentType = ""
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
    
    func getCartItems(){
        let url =  APIList().getUrlString(url: .CARTITEMS)
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
                                                let response = try JSONDecoder().decode(CartItemsModel.self, from: result!)
                                                self.cartItemsDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.cartItemsDelegate?.didFailDataUpdateWithError5(error: error)
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
                                        self.cartItemsDelegate?.didFailDataUpdateWithError5(error: error)
                                    })
    }
    
    func getCartDetails(){
        let url =  APIList().getUrlString(url: .CARTDETAILS)
        let parameter : Parameters = [
            "cartID" : cartID
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
                                                let response = try JSONDecoder().decode(CartDetailsModel.self, from: result!)
                                                self.cartDetailsDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.cartDetailsDelegate?.didFailDataUpdateWithError3(error: error)
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
                                        self.cartDetailsDelegate?.didFailDataUpdateWithError3(error: error)
                                    })
    }
    func checkOut(){
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
                                                self.cartCheckOutDelegate?.didRecieveDataUpdate1(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.cartCheckOutDelegate?.didFailDataUpdateWithError4(error: error)
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
                                        self.cartCheckOutDelegate?.didFailDataUpdateWithError4(error: error)
                                    })
    }
}
