//
//  APIList.swift
//  Paypaz
//
//  Created by MACOSX on 28/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit
struct APIList
{
    let BASE_URL = "http://amandeep.parastechnologies.in/paypaz/"
    func getUrlString(url: urlString) -> String
    {
        return BASE_URL + url.rawValue
    }
}
enum urlString:String
{
    case LOGIN = "user/login"
    case SIGNUP = "user/register"
    case VERIFYOTP = "user/verify/otp"
    case CREATEPROFILE = "user/profile/update"
    case FORGOTPASSWORD = "user/forgot/password"
    case CHANGEPASSWORD = "user/change/password"
    case RESETPASSWORD = "user/reset/password"
    case FORGOTPASSWORDOTP = "user/forgot/verify/otp"
    case RESENDOTP = "user/resend/otp"
    
    case PASSCODE = "user/passcode"
    case CREATEPASSCODE = "user/passcode/create"
    case CREATEPIN = "user/pincode/create"
    case FORGOTPASSCODEOTP = "user/passcode/otp"
    
    case USERDETAILS = "user/detail"
    case HOSTEVENT = "user/event/add"
    case UPDATEEVENT = "user/event/update"
    case DELETEEVENT = "event/delete/ID"
    case EVENTTYPES = "home/event/types"
    case ADDPRODUCT = "user/product/add"
    case MYEVENTSLIST = "user/events"
    case PARTICULAREVENTINFO = "home/event/detail"
    case MYPRODUCTS = "user/event/products"
    case PARTICULARPRODUCTINFO = "home/product/detail"
    case UPDATEPRODUCT = "user/product/update"
    case DELETEPRODUCT = "user/product/delete/"
    case CONTACTUS = "user/contactus"
    
    case USERIMAGE = "uploads/users/"
    case EVENTIMAGE = "uploads/types/"
    case UPLOADEDEVENTIMAGE = "uploads/events/"
    case UPLOADEDPRODUCTIMAGE = "uploads/products/"
}
