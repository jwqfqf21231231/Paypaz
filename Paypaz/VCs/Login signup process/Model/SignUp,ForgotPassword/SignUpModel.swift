//
//  SignUpModel.swift
//  Paypaz
//
//  Created by MACOSX on 28/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {
    let success,isAuthorized,isSuspended: Int?
    let message:String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let emailORphone, password, token, otp: String?
}
