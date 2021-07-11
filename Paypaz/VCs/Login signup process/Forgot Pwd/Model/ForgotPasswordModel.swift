//
//  ForgotPasswordModel.swift
//  Paypaz
//
//  Created by MACOSX on 30/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

// MARK: - ForgotPasswordModel
struct ForgotPasswordModel: Codable {
    let data: DataClass4?
    let success: Int?
    let message: String?
}

// MARK: - DataClass
struct DataClass4: Codable {
    let token, otp: String?
}
