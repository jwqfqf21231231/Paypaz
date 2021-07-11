//
//  MyPostedProductsModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - MyPostedProductsModel
struct MyPostedProductsModel: Codable {
    let data: [MyProducts]
    let success: Int
    let message: String
}

// MARK: - Datum
struct MyProducts: Codable {
    let id, userID, eventID, name: String
    let datumDescription, price, image, status: String
    let createdDate, updatedDate: String

    enum CodingKeys: String, CodingKey {
        case id, userID, eventID, name
        case datumDescription = "description"
        case price, image, status, createdDate, updatedDate
    }
}
