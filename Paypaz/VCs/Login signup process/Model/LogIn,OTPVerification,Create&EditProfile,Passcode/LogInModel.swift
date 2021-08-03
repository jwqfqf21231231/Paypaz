//
//  LogInModel.swift
//  Paypaz
//
//  Created by MACOSX on 29/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
// MARK: - LogInModel
struct LogInModel: Codable {
    let success: Int?
    let message: String?
    let messages: String?
    let data: DataClass2?
}

// MARK: - DataClass
struct DataClass2: Codable {
    let id, firstName, lastName, emailORphone: String?
        let email, phoneNumber, password, userProfile: String?
        let otp, passcode, dob, address: String?
        let latitude, longitude, city, state: String?
        let deviceToken, deviceType, deviceID, status: String?
        let createdDate, updatedDate, countryCode, phoneCode: String?
        let isNotification, isVerify, isProfile, isPasscode: String?
        let isPin, isVerifyCard, token: String?

        enum CodingKeys: String, CodingKey {
            case id, firstName, lastName, emailORphone, email, phoneNumber, password, userProfile, otp, passcode
            case dob = "DOB"
            case address, latitude, longitude, city, state, deviceToken, deviceType
            case deviceID = "deviceId"
            case status, createdDate, updatedDate, countryCode, phoneCode, isNotification, isVerify, isProfile, isPasscode, isPin, isVerifyCard, token
        }
}
struct CityCodable:Codable {
    var id, name :String?
}
