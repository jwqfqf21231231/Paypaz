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
    var search = ""
    var typeID = ""
    var pageNo = "0"
    var eventID = ""
    var isFilter = ""
    var distance = ""
    var day = ""
    var date = ""
    var status = ""
    var parameter : Parameters?
    func getFilteredEvents()
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        var currentDate = dateformatter.string(from: Date())
        currentDate = currentDate.localToUTC(incomingFormat: "yyyy-MM-dd HH:mm", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
        let url =  APIList().getUrlString(url: .FILTEREVENT)
        if isFilter == "1"{
            parameter  = [
                "isFilter" : isFilter,
                "latitude" : UserDefaults.standard.getLatitude(),
                "longitude" : UserDefaults.standard.getLongitude(),
                "distance" : distance,
                "currentDate" : currentDate,
                "pageNo" : pageNo,
                "date" : date,
                "typeID" : typeID
            ]
        }
        else if isFilter == "2"
        {
            parameter  = [
                "isFilter" : isFilter,
                "latitude" : UserDefaults.standard.getLatitude(),
                "longitude" : UserDefaults.standard.getLongitude(),
                "currentDate" : currentDate,
                "day" : day,
                "pageNo" : pageNo,
                "typeID" : typeID
            ]
        }
        else if isFilter == "0"{
            var distance = "20"
            if UserDefaults.standard.getDistance() != ""{
                distance = UserDefaults.standard.getDistance()
            }
            var date = ""
            if UserDefaults.standard.getDate() != ""{
                date = UserDefaults.standard.getDate()
            }
            var day = ""
            if UserDefaults.standard.getDay() != ""{
                day = UserDefaults.standard.getDay()
            }
            parameter  = [
                "isFilter" : isFilter,
                "latitude" : UserDefaults.standard.getLatitude(),
                "longitude" : UserDefaults.standard.getLongitude(),
                "currentDate" : currentDate,
                "pageNo" : pageNo,
                "search" : search,
                "distance" : distance,
                "date" : date,
                "day" : day,
                "typeID" : typeID
            ]
        }
        else{
            parameter  = [
                "isFilter" : isFilter,
                "latitude" : UserDefaults.standard.getLatitude(),
                "longitude" : UserDefaults.standard.getLongitude(),
                "currentDate" : currentDate,
                "pageNo" : pageNo,
                "typeID" : typeID
            ]
        }
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
