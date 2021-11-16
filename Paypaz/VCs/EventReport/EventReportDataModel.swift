//
//  EventReportDataModel.swift
//  Paypaz
//
//  Created by M1 on 16/11/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - EventReport
struct EventReportModel: Codable {
    let data: EventReport?
    let success: Int?
    let message: String?
}

// MARK: - EventReport
struct EventReport: Codable {
    let totalProducts, totalQtyProducts, totalProductQtySold, totalEventTicketSold: String?
    let totalSale, totalTicketEvent: String?
    enum CodingKeys: String, CodingKey {
        case totalProducts, totalQtyProducts, totalProductQtySold, totalEventTicketSold, totalSale
        case totalTicketEvent = "TotalTicketEvent"
    }
}

protocol EventReportDelegate:class {
    func didRecieveDataUpdate(data:EventReportModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class EventReporttDataModel: NSObject
{
    weak var delegate: EventReportDelegate?
    let sharedInstance = Connection()
    var eventID = ""
    func getEventReport()
    {
        let url =  APIList().getUrlString(url: .EventReport)
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
                                                let response = try JSONDecoder().decode(EventReportModel.self, from: result!)
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
