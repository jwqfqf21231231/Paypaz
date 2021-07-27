//
//  FavouritesDataModel.swift
//  Paypaz
//
//  Created by mac on 27/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol FavouritesListDataModelDelegate:class {
    func didRecieveDataUpdate(data:MyEventsListModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class FavouritesDataModel: NSObject
{
    weak var delegate: FavouritesListDataModelDelegate?
    let sharedInstance = Connection()
    var pageNo = "0"
    func getFavEvents()
    {
        let url =  APIList().getUrlString(url: .LISTFAVOURITE)
        let parameter : Parameters = [
            "pageNo" : pageNo
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
                                                let response = try JSONDecoder().decode(MyEventsListModel.self, from: result!)
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
