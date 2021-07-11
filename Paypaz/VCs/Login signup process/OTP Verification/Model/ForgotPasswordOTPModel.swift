//
//  ForgotPasswordOTPModel.swift
//  Paypaz
//
//  Created by MACOSX on 30/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - ForgotPasswordOTPModel
//This Model is used for both ForgotPasswordOTPVerify and ForgotPasscodeOTPVerify
struct ForgotPasswordOTPModel: Codable {
    let success: Int?
    let messages: String?
}
