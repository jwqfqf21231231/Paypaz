//
//  GetWalletAmount.swift
//  Paypaz
//
//  Created by MAC on 27/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - GetWalletAmount
struct GetWalletAmount: Codable {
    let data: WalletAmount?
    let success: Int?
    let message: String?
}

// MARK: - DataClass
struct WalletAmount: Codable {
    let userID, amount: String?
}

