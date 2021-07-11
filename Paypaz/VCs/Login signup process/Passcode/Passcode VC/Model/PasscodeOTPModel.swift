//
//  PasscodeOTPModel.swift
//  Paypaz
//
//  Created by MACOSX on 07/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import Foundation

// MARK: - PasscodeModel
struct PasscodeModel: Codable {
    let success: Int?
    let message: String?
    let data: PasscodeData?
}

// MARK: - DataClass
struct PasscodeData: Codable {
    let id, firstName, lastName, emailORphone: String?
    let email, phoneNumber, password, userProfile: String?
    let otp, passcode, dob, address: String?
    let latitude, longitude, city, state: String?
    let deviceToken, deviceType, deviceID, status: String?
    let createdDate, updatedDate, token: String?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, emailORphone, email, phoneNumber, password, userProfile, otp, passcode
        case dob = "DOB"
        case address, latitude, longitude, city, state, deviceToken, deviceType
        case deviceID = "deviceId"
        case status, createdDate, updatedDate, token
    }
}
