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
class AddProductDataModel: NSObject
{
    weak var delegate: AddProductDataModelDelegate?
    let sharedInstance = Connection()
    var productName = ""
    var productPrice = ""
    var productPic : UIImage?
    var productDescription = ""
    
    func addProduct()
    {
        let url =  APIList().getUrlString(url: .ADDPRODUCT)
        let parameter : [String:String] = [
            "name" : productName,
            "description" : productDescription,
            "price" : productPrice,
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
}
