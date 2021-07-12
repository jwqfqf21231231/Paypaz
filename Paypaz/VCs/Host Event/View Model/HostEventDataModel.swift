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
    var location = ""
    var price = ""
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    var isPublic = ""
    var isInviteMember = ""
    var paymentType = ""
    var memberID = ""
    var products = ""
    var eventImg : UIImage?
    var url = ""
    func addEvent()
    {
        if isEdit ?? false
        {
           url = APIList().getUrlString(url: .UPDATEEVENT)
        }
        else
        {
            url =  APIList().getUrlString(url: .HOSTEVENT)
        }
        let parameter : [String:String] = [
            "typeID" : typeId,
            "name" : name,
            "location" : location,
            "price" : price,
            "startDate" : startDate,
            "endDate" : endDate,
            "startTime" : startTime,
            "endTime" : endTime,
            "isPublic" : isPublic,
            "isInviteMember" : isInviteMember,
            "paymentType" : paymentType,
            "memberID" : memberID,
            "products" : products,
            "latitude" : UserDefaults.standard.getLatitude(),
            "longitude" : UserDefaults.standard.getLatitude()
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
}
