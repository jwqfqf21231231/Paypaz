//
//  UserTicketsDataModel.swift
//  Paypaz
//
//  Created by MAC on 04/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol UserTicketsDelegate:class {
    func didRecieveDataUpdate(data:UserTicketsModel)
    func didFailDataUpdateWithError(error:Error)
}
protocol TicketDetailsDelegate:class {
    func didRecieveDataUpdate(data:TicketDetailsModel)
    func didFailDataUpdateWithError(error:Error)
}
class UserTicketsDataModel: NSObject
{
    weak var userTicketsDelegate : UserTicketsDelegate?
    weak var ticketDetailsDelegate : TicketDetailsDelegate?
    let sharedInstance = Connection()
    var pageNo = ""
    var orderID = ""
    
    func getUserTickets()
    {
        
        let url =  APIList().getUrlString(url: .USERTICKETS)
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
                                                let response = try JSONDecoder().decode(UserTicketsModel.self, from: result!)
                                                self.userTicketsDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.userTicketsDelegate?.didFailDataUpdateWithError(error: error)
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
                                        self.userTicketsDelegate?.didFailDataUpdateWithError(error: error)
                                    })
    }
    func getTicketDetails()
    {
        
        let url =  APIList().getUrlString(url: .USERTICKETDETAIL)
        let parameter : Parameters = [
            "orderID" : orderID
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
                                                let response = try JSONDecoder().decode(TicketDetailsModel.self, from: result!)
                                                self.ticketDetailsDelegate?.didRecieveDataUpdate(data: response)
                                            }
                                            catch let error as NSError
                                            {
                                                self.ticketDetailsDelegate?.didFailDataUpdateWithError(error: error)
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
                                        self.ticketDetailsDelegate?.didFailDataUpdateWithError(error: error)
                                    })
    }
}
