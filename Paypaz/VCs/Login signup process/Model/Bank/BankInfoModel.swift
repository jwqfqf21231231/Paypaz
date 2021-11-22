//
//  BankInfo.swift
//  Paypaz
//
//  Created by MACOSX on 18/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - BankInfo
struct BankInfoModel: Codable {
    let data: [Bank]?
    let success: Int?
    let isAuthorized : Int?
    let isSuspended : Int?
    let message: String?
}

// MARK: - Datum
struct Bank: Codable {
    let id, bankName, bankType, status: String?
    let createdDate: String?
}
