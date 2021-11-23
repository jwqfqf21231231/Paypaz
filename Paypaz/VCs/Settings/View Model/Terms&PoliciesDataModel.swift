//
//  Terms&PoliciesDataModel.swift
//  Paypaz
//
//  Created by M1 on 16/11/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - TermsPolicies
struct TermsPoliciesModel: Codable {
    let data: Content?
    let success: Int?
    let isAuthorized: Int?
    let isSuspended: Int?
    let message: String?
}

// MARK: - DataClass
struct Content: Codable {
    let id, title, content, pageImage: String?
    let type, status, createdDate: String?
}

protocol Terms_PoliciesDelegate:class {
    func didRecieveDataUpdate(data:TermsPoliciesModel)
    func didFailDataUpdateWithError(error:Error)
    
}

class Terms_PoliciesDataModel: NSObject
{
    weak var delegate : Terms_PoliciesDelegate?
    let sharedInstance = Connection()
   
    func getContent()
    {
        let url =  APIList().getUrlString(url: .TermsPolicies)
        let parameter : Parameters = [
            "page" : "terms"
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
                                                let response = try JSONDecoder().decode(TermsPoliciesModel.self, from: result!)
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
