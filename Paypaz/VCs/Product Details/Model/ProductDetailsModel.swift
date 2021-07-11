//
//  ProductDetailsModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - ProductDetailsModel
struct ProductDetailsModel: Codable {
    let data: ProductInfo?
    let success: Int?
    let message: String?
}

// MARK: - DataClass
struct ProductInfo: Codable {
    let id, userID, eventID, name: String?
    let dataDescription, price, image, status: String?
    let createdDate, updatedDate: String?

    enum CodingKeys: String, CodingKey {
        case id, userID, eventID, name
        case dataDescription = "description"
        case price, image, status, createdDate, updatedDate
    }
}
