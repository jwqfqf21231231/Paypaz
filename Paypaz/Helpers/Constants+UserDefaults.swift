//
//  Constants+UserDefaults.swift
//  Paypaz
//
//  Created by MACOSX on 29/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

extension UserDefaults
{
//    func setLoggedIn(value: Bool)
//    {
//        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//    }
//
//    func isLoggedIn()-> Bool
//    {
//        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//    }
    func setFireBaseToken(value: String)
    {
        set(value, forKey: UserDefaultsKeys.fireBase.rawValue)
    }
    
    func getFireBaseToken()-> String
    {
        guard string(forKey: UserDefaultsKeys.fireBase.rawValue) != nil  else
        {
            return ""
        }
        return string(forKey: UserDefaultsKeys.fireBase.rawValue)!
    }
    func setLoggedIn(value: String)
    {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func getLoggedIn()-> String
    {
        guard string(forKey: UserDefaultsKeys.isLoggedIn.rawValue) != nil  else
        {
            return ""
        }
        return string(forKey: UserDefaultsKeys.isLoggedIn.rawValue)!
    }
    func setQRCode(value: String)
    {
        set(value, forKey: UserDefaultsKeys.QRCode.rawValue)
    }
    
    func getQRCode()-> String
    {
        guard string(forKey: UserDefaultsKeys.QRCode.rawValue) != nil  else
        {
            return ""
        }
        return string(forKey: UserDefaultsKeys.QRCode.rawValue)!
    }
    func setRegisterToken(value:String)
    {
        set(value, forKey: UserDefaultsKeys.registerToken.rawValue)
    }
    func getRegisterToken() -> String
    {
        guard string(forKey: UserDefaultsKeys.registerToken.rawValue) != nil  else
        {
            return ""
        }
        return string(forKey: UserDefaultsKeys.registerToken.rawValue)!
    }
    func setLatitude(value:String)
    {
        set(value,forKey: UserDefaultsKeys.latitude.rawValue)
    }
    func getLatitude() -> String
    {
        guard string(forKey: UserDefaultsKeys.latitude.rawValue) != nil else {
            return ""
        }
        return string(forKey: UserDefaultsKeys.latitude.rawValue) ?? ""
    }
    func setLongitude(value:String)
    {
        set(value,forKey: UserDefaultsKeys.longitude.rawValue)
    }
    func getLongitude() -> String
    {
        guard string(forKey: UserDefaultsKeys.longitude.rawValue) != nil else {
            return ""
        }
        return string(forKey: UserDefaultsKeys.longitude.rawValue) ?? ""
    }
    func setPasscode(value:String)
    {
        set(value,forKey: UserDefaultsKeys.passcode.rawValue)
    }
    func getPasscode() -> String
    {
        guard string(forKey: UserDefaultsKeys.passcode.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.passcode.rawValue) ?? ""
    }
    func setPin(value:String)
    {
        set(value,forKey: UserDefaultsKeys.pin.rawValue)
    }
    func getPin() -> String
    {
        guard string(forKey: UserDefaultsKeys.pin.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.pin.rawValue) ?? ""
    }
    func setEmail(value:String)
    {
        set(value,forKey: UserDefaultsKeys.email.rawValue)
    }
    func getEmail() -> String
    {
        guard string(forKey: UserDefaultsKeys.email.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.email.rawValue) ?? ""
    }
    func setPhoneNo(value:String)
    {
        set(value,forKey: UserDefaultsKeys.phoneNo.rawValue)
    }
    func getPhoneNo() -> String
    {
        guard string(forKey: UserDefaultsKeys.phoneNo.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.phoneNo.rawValue) ?? ""
    }
    func setNotificationStatus(value:String)
    {
        set(value,forKey: UserDefaultsKeys.notificationStatus.rawValue)
    }
    func getNotificationStatus() -> String
    {
        guard string(forKey: UserDefaultsKeys.notificationStatus.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.notificationStatus.rawValue) ?? ""
    }
    func setPhoneCode(value:String)
    {
        set(value,forKey: UserDefaultsKeys.phoneCode.rawValue)
    }
    func getPhoneCode() -> String
    {
        guard string(forKey: UserDefaultsKeys.phoneCode.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.phoneCode.rawValue) ?? ""
    }
    func setCountryCode(value:String)
    {
        set(value,forKey: UserDefaultsKeys.countryCode.rawValue)
    }
    func getCountryCode() -> String
    {
        guard string(forKey: UserDefaultsKeys.countryCode.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.countryCode.rawValue) ?? ""
    }
    func setUserID(value:String)
    {
        set(value,forKey: UserDefaultsKeys.userID.rawValue)
    }
    func getUserID() -> String
    {
        guard string(forKey: UserDefaultsKeys.userID.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.userID.rawValue) ?? ""
    }
    func setDistance(value:String)
    {
        set(value,forKey: UserDefaultsKeys.distance.rawValue)
    }
    func getDistance() -> String
    {
        guard string(forKey: UserDefaultsKeys.distance.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.distance.rawValue) ?? ""
    }
    func setDate(value:String)
    {
        set(value,forKey: UserDefaultsKeys.date.rawValue)
    }
    func getDate() -> String
    {
        guard string(forKey: UserDefaultsKeys.date.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.date.rawValue) ?? ""
    }
    func setDay(value:String)
    {
        set(value,forKey: UserDefaultsKeys.day.rawValue)
    }
    func getDay() -> String
    {
        guard string(forKey: UserDefaultsKeys.day.rawValue) != nil
            else{
                return ""
        }
        return string(forKey: UserDefaultsKeys.day.rawValue) ?? ""
    }
}


enum UserDefaultsKeys : String
{
    case userID
    case isLoggedIn
    case QRCode
    case registerToken
    case loginToken
    case latitude
    case longitude
    case passcode
    case pin
    case email
    case phoneNo
    case notificationStatus
    case phoneCode
    case countryCode
    case distance
    case date
    case day
    case fireBase
}

