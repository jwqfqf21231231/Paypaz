//
//  HostEventDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol HostEventDataModelDelegate:class {
    func didRecieveDataUpdate(data:HostEventModel)
    func didFailDataUpdateWithError3(error:Error)
    
}
class HostEventDataModel: NSObject
{
    var isEdit : Bool?
    weak var delegate: HostEventDataModelDelegate?
    let sharedInstance = Connection()
    var typeId = ""
    var name = ""
    var eventDescription = ""
    var location = ""
    var latitude = ""
    var longitude = ""
    var price = ""
    var eventQuantity = ""
    var startDate = ""
    var endDate = ""
    var paymentType = ""
    var eventImg : UIImage?
    var eventID = ""
    
    var url = ""
    var parameter = [String:String]()
    func addEvent()
    {
        
        url =  APIList().getUrlString(url: .HOSTEVENT)
        parameter = [
            "typeID" : typeId,
            "name" : name,
            "description" : eventDescription,
            "location" : location,
            "latitude" : latitude,
            "longitude" : longitude,
            "price" : price,
            "quantity" : eventQuantity,
            "startDate" : startDate,
            "endDate" : endDate,
            "paymentType" : paymentType
        ]
        
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        sharedInstance.uploadImage(url, imgData: eventImg!.jpegData(compressionQuality: 0.25)!,
                                   params: parameter,
                                   headers: header,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(HostEventModel.self, from: result!)
                                                self.delegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate?.didFailDataUpdateWithError3(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError3(error: error)
                                    })
    }
    func updateEvent()
    {
        url = APIList().getUrlString(url: .UPDATEEVENT)
        parameter = [
            "typeID" : typeId,
            "name" : name,
            "description" : eventDescription,
            "location" : location,
            "price" : price,
            "startDate" : startDate,
            "endDate" : endDate,
            "paymentType" : paymentType,
            "latitude" : latitude,
            "longitude" : longitude,
            "quantity" : eventQuantity,
            "eventID" : eventID
        ]
        sharedInstance.uploadImage(url, imgData: eventImg!.jpegData(compressionQuality: 0.25)!,
                                   params: parameter,
                                   headers: nil,
                                   success:
                                    {
                                        (JSON) in
                                        let  result :Data? = JSON
                                        if result != nil
                                        {
                                            do
                                            {
                                                let response = try JSONDecoder().decode(HostEventModel.self, from: result!)
                                                self.delegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate?.didFailDataUpdateWithError3(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError3(error: error)
                                    })
    }
}
