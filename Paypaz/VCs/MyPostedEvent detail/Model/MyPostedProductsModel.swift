//
//  MyPostedProductsModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - MyPostedProductsModel
class MyPostedProductsModel: Codable {
    let data: [MyProducts]?
    let success,isAuthorized,isSuspended: Int?
    let message: String?
}

// MARK: - Datum
class MyProducts: Codable {
    let id, userID, eventID, name: String?
    let dataDescription, price, quantity, image: String?
    let isPaid, status, createdDate, updatedDate: String?
    var updatedProductPrice:Float = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id, userID, eventID, name
        case dataDescription = "description"
        case price, quantity, image, isPaid, status, createdDate, updatedDate
    }
}
