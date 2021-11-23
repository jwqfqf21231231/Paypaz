//
//  TicketDetailsModel.swift
//  Paypaz
//
//  Created by MAC on 04/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import Foundation

// MARK: - TicketDetailsModel
struct TicketDetailsModel: Codable {
    let data: TicketDetails?
    let success: Int?
    let isAuthorized: Int?
    let isSuspended: Int?
    let message: String?
}

// MARK: - DataClass
struct TicketDetails: Codable {
    let orderNumber, grandTotal, id, name: String?
    let dataDescription, endDate, image, price: String?
    let typeID, paymentMethod, firstName, lastName: String?
    let userProfile, typeName: String?
    let products: [TicketProducts]?

    enum CodingKeys: String, CodingKey {
        case orderNumber, grandTotal, id, name
        case dataDescription = "description"
        case endDate, image, price, typeID, paymentMethod, firstName, lastName, userProfile, typeName, products
    }
}

// MARK: - Product
struct TicketProducts: Codable {
    let id, orderID, eventID, productID: String?
    let productPrice, productQty, productQtyPrice, status: String?
    let createdDate, updatedDate, name, image: String?
}

//import Foundation
//
//// MARK: - UserTickets
//struct TicketDetailsModel: Codable {
//    let data: TicketDetails?
//    let success: Int?
//    let message: String?
//}
//
//// MARK: - DataClass
//struct TicketDetails: Codable {
//    let orderNumber, id, grandTotal, name, dataDescription: String?
//    let endDate, image, price, typeID: String?
//    let paymentMethod, firstName, lastName, userProfile: String?
//    let typeName: String?
//    let products: [TicketProducts]?
//
//    enum CodingKeys: String, CodingKey {
//        case orderNumber, id, name
//        case dataDescription = "description"
//        case endDate, image, price, typeID, paymentMethod, firstName, lastName, userProfile, typeName, products
//    }
//}
//
//// MARK: - Product
//struct TicketProducts: Codable {
//    let id, orderID, eventID, productID: String?
//    let productPrice, productQty, productQtyPrice, status: String?
//    let createdDate, updatedDate, name, image: String?
//}
