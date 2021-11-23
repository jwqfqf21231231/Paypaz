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
    let data: MyProducts?
    let success: Int?
    let isAuthorized: Int?
    let isSuspended: Int?
    let message: String?
}

