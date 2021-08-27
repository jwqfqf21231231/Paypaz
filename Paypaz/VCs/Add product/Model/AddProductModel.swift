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
    let data: MyProducts?
    let success: Int?
    let message: String?
}

