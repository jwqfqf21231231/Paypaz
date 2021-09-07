//
//  NotificationListDataModel.swift
//  Paypaz
//
//  Created by MAC on 07/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import Foundation
import Alamofire

protocol NotificationListDataModelDelegate:class {
    func didRecieveDataUpdate(data:InvitesListModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class NotificationListDataModel: NSObject
{
    weak var delegate: NotificationListDataModelDelegate?
    let sharedInstance = Connection()
    var pageNo = "0"
    var parameter : Parameters = [:]
    func getNotifications()
    {
        
        let url =  APIList().getUrlString(url: .NOTIFICATIONLIST)
        
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
                                                let response = try JSONDecoder().decode(InvitesListModel.self, from: result!)
                                                self.delegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.delegate?.didFailDataUpdateWithError(error: error)
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
                                        self.delegate?.didFailDataUpdateWithError(error: error)
                                        
                                    })
    }
    
}
