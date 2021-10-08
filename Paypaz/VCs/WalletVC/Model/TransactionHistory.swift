//
//  TransactionHistory.swift
//  Paypaz
//
//  Created by MAC on 07/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - TransactionHistory
struct TransactionHistoryModel: Codable {
    let data: [Transactions]?
    let success: Int?
    let message: String?
}

// MARK: - Datum
struct Transactions: Codable {
    let amount, isCredited, firstName, lastName: String?
    let userProfile, name: String?
}


