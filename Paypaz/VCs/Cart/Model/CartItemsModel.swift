//
//  CartItemsModel.swift
//  Paypaz
//
//  Created by MAC on 23/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - CartItems
struct CartItemsModel: Codable {
    let data: [CartInfo]?
    let success,isAuthorized: Int?
    let message: String?
}
