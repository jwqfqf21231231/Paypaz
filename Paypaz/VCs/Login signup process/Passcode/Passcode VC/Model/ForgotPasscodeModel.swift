//
//  ForgotPasscodeModel.swift
//  Paypaz
//
//  Created by MACOSX on 09/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import Foundation

// MARK: - ForgotPasscodeModel
struct ForgotPasscodeModel: Codable {
    let otp, success: Int?
    let message: String?
}
