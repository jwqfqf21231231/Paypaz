//
//  AddProductDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol AddProductDataModelDelegate:class {
    func didRecieveDataUpdate(data:AddProductModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol EditProductDataModelDelegate:class {
    func didRecieveDataUpdate3(data:AddProductModel)
    func didFailDataUpdateWithError3(error:Error)}
class AddProductDataModel: NSObject
{
    weak var delegate : AddProductDataModelDelegate?
    weak var delegate2 : EditProductDataModelDelegate?
    let sharedInstance = Connection()
    var eventID = ""
    var productName = ""
    var productPrice = ""
    var productQuantity = ""
    var productPic : UIImage?
    var productDescription = ""
    
    var productID = ""
    
    func addProduct()
    {
        let url =  APIList().getUrlString(url: .ADDPRODUCT)
        let parameter : [String:String] = [
            "name" : productName,
            "price" : productPrice,
            "description" : productDescription,
            "quantity" : productQuantity,
            "eventID" : eventID
        ]
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.uploadImage(url, imgData: productPic!.jpegData(compressionQuality: 0.25)!, params: parameter, headers: header,success:
                                        {
                                            (JSON) in
                                            let  result :Data? = JSON
                                            if result != nil
                                            {
                                                do
                                                {
                                                    let response = try JSONDecoder().decode(AddProductModel.self, from: result!)
                                                    self.delegate?.didRecieveDataUpdate(data: response)
                                                }
                                                catch let error as NSError
                                                {
                                                    self.delegate?.didFailDataUpdateWithError(error: error)
                                                }
                                            }
                                        },
                                       failure:
                                        {
                                            (error) in
                                            self.delegate?.didFailDataUpdateWithError(error: error)
                                            
                                        })
                                   
    }
    func editProduct()
    {
        let url =  APIList().getUrlString(url: .UPDATEPRODUCT)
        let parameter : [String:String] = [
            "name" : productName,
            "description" : productDescription,
            "price" : productPrice,
            "productID" : productID,
            "quantity" : productQuantity
        ]
        sharedInstance.uploadImage(url, imgData: productPic!.jpegData(compressionQuality: 0.25)!, params: parameter, headers: nil,success:
                                        {
                                            (JSON) in
                                            let  result :Data? = JSON
                                            if result != nil
                                            {
                                                do
                                                {
                                                    let response = try JSONDecoder().decode(AddProductModel.self, from: result!)
                                                    self.delegate2?.didRecieveDataUpdate3(data: response)
                                                }
                                                catch let error as NSError
                                                {
                                                    self.delegate2?.didFailDataUpdateWithError3(error: error)
                                                }
                                            }
                                        },
                                       failure:
                                        {
                                            (error) in
                                            self.delegate2?.didFailDataUpdateWithError3(error: error)
                                            
                                        })
    }
}
