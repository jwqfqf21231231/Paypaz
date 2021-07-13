//
//  ProductDetailsDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol ProductDetailsDataModelDelegate:class {
    func didRecieveDataUpdate(data:ProductDetailsModel)
    func didFailDataUpdateWithError2(error:Error)
}
protocol DeleteProductDataModelDelegate:class {
    func didRecieveDataUpdate(data:SuccessModel)
    func didFailDataUpdateWithError3(error:Error)
    
}
class ProductDetailsDataModel: NSObject
{
    weak var delegate : ProductDetailsDataModelDelegate?
    weak var delegate2 : DeleteProductDataModelDelegate?
    let sharedInstance = Connection()
    var productID = ""
    func getProductDetails()
    {
        let url =  APIList().getUrlString(url: .PARTICULARPRODUCTINFO)
        
        let parameter : Parameters = [
            "productID" : productID
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
                                                let response = try JSONDecoder().decode(ProductDetailsModel.self, from: result!)
                                                self.delegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate?.didFailDataUpdateWithError2(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError2(error: error)
                                    })
    }
    func deleteProduct()
    {
        var url =  APIList().getUrlString(url: .DELETEPRODUCT)
        url = url + "\(productID)"
        sharedInstance.requestDELETE(url, params: nil, headers: nil,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(SuccessModel.self, from: result!)
                                                self.delegate2?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate2?.didFailDataUpdateWithError3(error: error)
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
                                        self.delegate2?.didFailDataUpdateWithError3(error: error)
                                        
                                    })
    }
}
