//
//  BuyEventDataModel.swift
//  Paypaz
//
//  Created by mac on 26/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol FavEventDataModelDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError1(error:Error)
}
protocol FilteredEventDataModelDelegate:class{
    func didRecieveDataUpdate1(data:MyEventsListModel)
    func didFailDataUpdateWithError2(error:Error)
}
class BuyEventDataModel: NSObject
{
    weak var delegate1: FavEventDataModelDelegate?
    weak var delegate2: FilteredEventDataModelDelegate?
    let sharedInstance = Connection()
    var typeID = ""
    var pageNo = "0"
    var eventID = ""
    var isFilter = ""
    var distance = ""
    var search = ""
    var day = ""
    var date = ""
    var status = ""
    func getFilteredEvents()
    {
        let url =  APIList().getUrlString(url: .FILTEREVENT)
        let parameter : Parameters = [
            "isFilter" : isFilter,
            "latitude" : UserDefaults.standard.getLatitude(),
            "longitude" : UserDefaults.standard.getLongitude(),
            "distance" : distance,
            "day" : day,
            "pageNo" : pageNo,
            "date" : date,
            "typeID" : typeID
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
                                                self.delegate2?.didRecieveDataUpdate1(data: response)
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
    func favEvent()
    {
        let url =  APIList().getUrlString(url: .ADDFAV)
        let parameter : Parameters = [
            "eventID" : eventID,
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
                                                let response = try JSONDecoder().decode(ResendOTPModel.self, from: result!)
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

}
