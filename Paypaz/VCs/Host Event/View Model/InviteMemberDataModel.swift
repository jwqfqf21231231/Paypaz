//
//  InviteMemberDataModel.swift
//  Paypaz
//
//  Created by MAC on 20/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Alamofire

protocol InviteMemberDataModelDelegate:class {
    func didRecieveDataUpdate(data:ResendOTPModel)
    func didFailDataUpdateWithError(error:Error)
    
}
class InviteMemberDataModel: NSObject
{
    weak var delegate: InviteMemberDataModelDelegate?
    let sharedInstance = Connection()
    var eventID = ""
    var isPublic = ""
    var isInviteMember = ""
    var contacts:NSString = ""
    var parameter : Parameters = [:]
    func inviteMembers()
    {
        
        let url =  APIList().getUrlString(url: .INVITEMEMBERS)
        let parameter : Parameters = [
            "eventID" : "58" ,
            "isPublic" : isPublic,
            "isInviteMember" : isInviteMember,
            "contacts" : contacts,
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

