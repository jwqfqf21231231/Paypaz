//
//  CreateProfileDataModel.swift
//  Paypaz
//
//  Created by MACOSX on 29/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

protocol CreateProfileDataModelDelegate:class {
    func didRecieveDataUpdate(data:LogInModel)
    func didFailDataUpdateWithError1(error:Error)
}

class CreateProfileDataModel: NSObject
{
    weak var delegate: CreateProfileDataModelDelegate?
    let sharedInstance = Connection()
    var firstName = ""
    var lastName = ""
    var email = ""
    var dateOfBirth = ""
    var city = ""
    var state = ""
    var address = ""
    var isUpdate = ""
    var parameter : [String:String] = [:]
    var profilePic : UIImage?
    
    func uploadProImg(){
        let url = APIList().getUrlString(url: .CREATEPROFILE)
        let sharedInstance = Connection()
        if isUpdate == "0"{
            parameter = [
                "firstName":firstName,
                "lastName":lastName,
                "email":email,
                "DOB":dateOfBirth,
                "city":city,
                "state":state,
                "address":address,
                "isUpdate":isUpdate
            ]
        }
        else
        {
            parameter = [
                "firstName":firstName,
                "lastName":lastName,
                "DOB":dateOfBirth,
                "city":city,
                "state":state,
                "address":address,
                "isUpdate":isUpdate
            ]
        }
        
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getRegisterToken())"
        ]
        
        sharedInstance.uploadProImage(url, imgData: profilePic!.jpegData(compressionQuality: 0.25)!,
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
                                                        let response = try  JSONDecoder().decode(LogInModel.self, from: result!)
                                                        self.delegate?.didRecieveDataUpdate(data: response)
                                                    }
                                                catch let error as NSError
                                                {
                                                    self.delegate?.didFailDataUpdateWithError1(error: error)
                                                }
                                            }
                                        },
                                      failure:
                                        {
                                            (error) in
                                            self.delegate?.didFailDataUpdateWithError1(error: error)
                                        })
    }
    
}
