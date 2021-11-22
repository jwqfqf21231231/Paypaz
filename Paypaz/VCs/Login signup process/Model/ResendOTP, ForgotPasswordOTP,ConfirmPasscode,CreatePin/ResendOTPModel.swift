//
//  ResendOTPModel.swift
//  Paypaz
//
//  Created by MACOSX on 01/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - ResendOTPModel
struct ResendOTPModel: Codable {
    let success,isAuthorized,isSuspended: Int?
    let message, otp, data: String?
}


struct Basic_Model:Codable {
    let success:Int?
    let isAuthorized:Int?
    let isSuspended:Int?
    let message:String?
}
