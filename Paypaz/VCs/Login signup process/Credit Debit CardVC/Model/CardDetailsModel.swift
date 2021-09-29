//
//  CardDetailsModel.swift
//  Paypaz
//
//  Created by MAC on 29/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - CardsListModel
struct CardDetailsModel: Codable {
    let data: CardsList?
    let success: Int?
    let message: String?
}
