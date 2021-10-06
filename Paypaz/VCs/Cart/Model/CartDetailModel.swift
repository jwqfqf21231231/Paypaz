//
//  CartDetailModel.swift
//  Paypaz
//
//  Created by MAC on 23/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - CartDetail
struct CartDetailsModel: Codable {
    let data: CartInfo?
    let success: Int?
    let message: String?
}

// MARK: - CartInfo
struct CartInfo: Codable {
    let id, orderNumber, userID, eventID: String?
    let eventUserID, cardID, eventQty, eventPrice, productsPrice: String?
    let subTotal, discount, tax, grandTotal, hostAmount, adminAmount: String?
    let addedDate, paymentMethod, type, userStatus: String?
    let status, transactionID, merchantReference, transactionTime, createdDate, updatedDate, name: String?
    let location, image, startDate, endDate, price, paymentType: String?
    let products: [Product]?
}

// MARK: - Product
struct Product: Codable {
    let id, orderID, eventID, productID: String?
    let productPrice, productQty, productQtyPrice, status: String?
    let createdDate, updatedDate, name, image: String?
    var updatedProductPrice :Int?
}
