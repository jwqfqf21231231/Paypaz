//
//  PaymentCardsList.swift
//  Paypaz
//
//  Created by MAC on 29/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - CardsListModel
struct CardsListModel: Codable {
    let data: [CardsList]?
    let success: Int?
    let message: String?
}

// MARK: - CardInfo
struct CardsList: Codable {
    let id, userID, bankID, cardName, cardHolderName: String?
    let cardNumber, expDate, status, createdDate: String?
    let updatedDate: String?
}
