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
    let BASE_URL = "https://parastechnologies.in/paypaz/"
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
    case CARDLIST = "user/card/listing"
    case DELETECARD = "user/card/delete/"
    case CARDDETAIL = "user/card/detail"
    case ADDBANKACCOUNT = "user/bank/create"
    
    case PASSCODE = "user/passcode"
    case CREATEPASSCODE = "user/passcode/create"
    case CREATEPIN = "user/pincode/create"
    case FORGOTPASSCODEOTP = "user/passcode/otp"
    
    case USERDETAILS = "user/detail"
    case USERPROFILE = "home/user/profile"
    
    case HOSTEVENT = "user/event/add"
    case UPDATEEVENT = "user/event/update"
    case DELETEEVENT = "user/event/delete/"
    case EVENTTYPES = "home/event/types"
    case MYEVENTSLIST = "user/events"
    case PARTICULAREVENTINFO = "home/event/detail"
    case GETEVENTACCTOTYPES = "home/type/events"
    case GETEVENTACCTOUSERID = "home/events/list"
    case ADDFAV = "user/event/favourite/add"
    case LISTFAVOURITE = "user/favourite/list"
    case FILTEREVENT = "home/event/filter"
    
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
    
    case NOTIFICATIONLIST = "user/notification/list"
    case CLEARNOTIFICATIONS = "user/notifications/clear"
    
    case INVITELIST = "user/invite/list"
    case ACCEPTORREJECTINVITE = "user/invite/change/status"
    
    case ADDTOCART = "home/event/cart/add"
    case CARTITEMS = "user/carts"
    case CARTDETAILS = "user/cart/detail"
    
    case ADDAMOUNTINWALLET = "user/wallet/add"
    case GETWALLETAMOUNT = "user/wallet"
    
    case USERIMAGE = "uploads/users/"
    case EVENTIMAGE = "uploads/types/"
    case UPLOADEDEVENTIMAGE = "uploads/events/"
    case UPLOADEDPRODUCTIMAGE = "uploads/products/"
    
    case LOGOUT = "user/logout"
}
