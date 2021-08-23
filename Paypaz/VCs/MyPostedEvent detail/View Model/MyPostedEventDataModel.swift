//
//  MyPostedEventDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol MyPostedEventDataModelDelegate:class {
    func didRecieveDataUpdate(data:MyPostedEventModel)
    func didFailDataUpdateWithError(error:Error)
    
}
protocol MyPostedProductsDataModelDelegate:class {
    func didRecieveDataUpdate(data:MyPostedProductsModel)
    func didFailDataUpdateWithError2(error:Error)
}
protocol MyPostedContactsDataModelDelegate:class {
    func didRecieveDataUpdate(data:MyPostedContactsModel)
    func didFailDataUpdateWithError2(error:Error)
}
class MyPostedEventDataModel: NSObject
{
    var eventID = ""
    var pageNO = "0"
    weak var delegate: MyPostedEventDataModelDelegate?
    weak var delegate2: MyPostedProductsDataModelDelegate?
    weak var delegate3: MyPostedContactsDataModelDelegate?
    let sharedInstance = Connection()
    func getEvent()
    {
        let url =  APIList().getUrlString(url: .PARTICULAREVENTINFO)
        let parameter : Parameters = [
            "eventID" : eventID
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
                                                let response = try JSONDecoder().decode(MyPostedEventModel.self, from: result!)
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
    func getProducts()
    {
        let url =  APIList().getUrlString(url: .MYPRODUCTS)
        let parameter : Parameters = [
            "eventID" : eventID,
            "pageNO" : pageNO
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
                                                let response = try JSONDecoder().decode(MyPostedProductsModel.self, from: result!)
                                                self.delegate2?.didRecieveDataUpdate(data: response)
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
    func getContacts()
    {
        let url =  APIList().getUrlString(url: .CONTACTLIST)
        let parameter : Parameters = [
            "eventID" : eventID
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
                                                let response = try JSONDecoder().decode(MyPostedProductsModel.self, from: result!)
                                                self.delegate2?.didRecieveDataUpdate(data: response)
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
