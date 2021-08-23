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
    case BANKINFO = "home/banks"
    case CREATECARD = "user/card/create"
    case ADDBANKACCOUNT = "user/bank/create"
    
    case PASSCODE = "user/passcode"
    case CREATEPASSCODE = "user/passcode/create"
    case CREATEPIN = "user/pincode/create"
    case FORGOTPASSCODEOTP = "user/passcode/otp"
    
    case USERDETAILS = "user/detail"
    case HOSTEVENT = "user/event/add"
    case UPDATEEVENT = "user/event/update"
    case DELETEEVENT = "user/event/delete/"
    case EVENTTYPES = "home/event/types"
    case MYEVENTSLIST = "user/events"
    case PARTICULAREVENTINFO = "home/event/detail"
    case GETEVENTACCTOTYPES = "home/type/events"
    case ADDFAV = "user/event/favourite/add"
    case LISTFAVOURITE = "user/favourite/list"
    
    case ADDPRODUCT = "user/product/add"
    case MYPRODUCTS = "user/event/products"
    case PARTICULARPRODUCTINFO = "home/product/detail"
    case UPDATEPRODUCT = "user/product/update"
    case DELETEPRODUCT = "user/product/delete"
    
    case INVITEMEMBERS = "user/contacts/add"
    case CONTACTLIST = "user/event/contacts"
    
    case CONTACTUS = "user/contactus"
    case NOTIFICATIONSTATUS = "user/notification/status"
    
    case CHANGEPHONENUMBER = "user/phone/otp"
    case VERIFYCHANGEDPHONENUMBER = "user/phone/update"
    
    case USERIMAGE = "uploads/users/"
    case EVENTIMAGE = "uploads/types/"
    case UPLOADEDEVENTIMAGE = "uploads/events/"
    case UPLOADEDPRODUCTIMAGE = "uploads/products/"
    
    case LOGOUT = "user/logout"
}
