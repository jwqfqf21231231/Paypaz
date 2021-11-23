//
//  TransactionHistory.swift
//  Paypaz
//
//  Created by MAC on 07/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

/*import Foundation

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
}*/

import Foundation

// MARK: - Welcome
struct TransactionHistoryModel: Codable {
    let data: [Transactions]?
    let success,isAuthorized,isSuspended: Int?
    let message: String?
}

// MARK: - Datum
struct Transactions: Codable {
    let id, walletID, userID, receiverID: String?
    let cardID, orderID, requestID: String?
    let transactionID: String?
    let amount: String?
    let merchantReference: String?
    let transactionTime, status, isCredited, createdDate: String?
    let updatedDate: String?
    let firstName: String?
    let lastName: String?
    let userProfile: String?
    let name: String?
    let type: String?
}
