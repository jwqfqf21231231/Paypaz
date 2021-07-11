//
//  AddProductModel.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - AddProductModel
struct AddProductModel: Codable {
    let data: DataClass7?
    let success: Int?
    let message: String?
}

// MARK: - DataClass
struct DataClass7: Codable {
    let id, userID, eventID, name: String?
    let dataDescription, price, image, status: String?
    let createdDate, updatedDate: String?

    enum CodingKeys: String, CodingKey {
        case id, userID, eventID, name
        case dataDescription = "description"
        case price, image, status, createdDate, updatedDate
    }
}
