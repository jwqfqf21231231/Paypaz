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
    let success: Int?
    let messages, data: String?
}
