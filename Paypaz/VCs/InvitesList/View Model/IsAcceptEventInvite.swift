//
//  IsAcceptEventInvite.swift
//  Paypaz
//
//  Created by MAC on 07/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol IsAcceptEventInviteDataModelDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class IsAcceptEventInviteDataModel: NSObject
{
    weak var delegate: IsAcceptEventInviteDataModelDelegate?
    let sharedInstance = Connection()
    var isAccept = ""
    var inviteID = ""
    var parameter : Parameters = [:]
    func acceptOrInvite()
    {
        
        let url =  APIList().getUrlString(url: .ACCEPTORREJECTINVITE)
        
        let parameter : Parameters = [
            "isAccept" : isAccept,
            "inviteID" : inviteID
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

