//
//  Connection.swift
//  Paypaz
//
//  Created by MACOSX on 28/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


class Connectivity
{
    class func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}
class Connection
{
    
    class func alert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    
    
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show(withStatus: title);
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        view.view.isUserInteractionEnabled = false;
    }
    
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            view.view.isUserInteractionEnabled = true
        }
        
    }
    
    
    
    func requestPOST(_ url: String, params : Parameters?, headers : HTTPHeaders?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        print("URL = ",url)
        print("Parameter = ",params ?? [:])
        
        if Connectivity.isConnectedToInternet()
        {
            if headers == nil
            {
                Alamofire.request(url, method: .post, parameters: params!, encoding: URLEncoding.httpBody, headers: nil).responseJSON
                {
                    (responseObject) -> Void in
                    
                    print("Response = ",responseObject)
                    
                    switch responseObject.result
                    {
                    case .success:
                        if let data = responseObject.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                        print(error)
                    }
                }
            }
            else
            {
                
                print("Headers = ",headers!)
                
                Alamofire.request(url, method: .post, parameters: params ?? [:], encoding: URLEncoding.httpBody, headers: headers ?? [:]).responseJSON
                {
                    (responseObject) -> Void in
                    
                    print("Response = ",responseObject)
                    
                    switch responseObject.result
                    {
                    case .success:
                        if let data = responseObject.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
            
        }
        else
        {
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : "Check Internet Connection"])
            failure(error)
        }
    }
    
    
    func requestGET(_ url: String, params : Parameters?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        print("URL = ",url)
        print("Parameter = ",params)
        print("Headers = ",headers)
        
        
        if Connectivity.isConnectedToInternet()
        {
            do
            {
                Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON
                {
                    (response) in
                    
                    print("Response = ",response)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
            catch let JSONError as NSError
            {
                failure(JSONError)
            }
        }
        else
        {
            
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : "Check Internet Connection"])
            failure(error)
        }
        
    }
    
    func requestURLEncodingGET(_ url: String, params : Parameters?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        if Connectivity.isConnectedToInternet()
        {
            do
            {
                Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON
                {
                    (response) in
                    
                    debugPrint("Response = ",response)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
            catch let JSONError as NSError
            {
                failure(JSONError)
            }
        }
        else
        {
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : "Check Internet Connection"])
            failure(error)
        }
        
    }
    
    func uploadImage(_ url: String,imgData:Data, params :[String:String]?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        
        //Optional for extra parameter
        Alamofire.upload(multipartFormData: { multipartFormData in multipartFormData.append(imgData, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
            for (key, value) in params! { multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key) } //Optional for extraparameters
            
        },
        to:url,method:.post, headers: headers) {
            (result) in switch result { case .success(let upload, _, _): upload.uploadProgress(closure: { (progress) in
                                                                                                print("url",url)
                                                                                                print("parameters",params!)
                                                                                                print("Upload Progress: \(progress.fractionCompleted)") })
                upload.response(completionHandler: { (dataRes) in
                    print(dataRes)
                })
                upload.responseJSON { response in
                    //print("UPLOAD SUCCESS",response.result.value!)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                failure(encodingError)
            } }
    }
    
    func uploadProImage(_ url: String,imgData:Data, params :[String:String]?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        
        //Optional for extra parameter
        Alamofire.upload(multipartFormData: { multipartFormData in multipartFormData.append(imgData, withName: "userProfile",fileName: "userProfile.jpg", mimeType: "image/jpg")
            for (key, value) in params! { multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key) } //Optional for extraparameters
            
        },
        to:url,method:.post, headers: headers) {
            (result) in switch result { case .success(let upload, _, _): upload.uploadProgress(closure: { (progress) in
                                                                                                print("url",url)
                                                                                                print("parameters",params!)
                                                                                                print("Upload Progress: \(progress.fractionCompleted)") })
                upload.response(completionHandler: { (dataRes) in
                    print(dataRes)
                })
                upload.responseJSON { response in
                    //print("UPLOAD SUCCESS",response.result.value!)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                failure(encodingError)
            } }
    }
    
    
    func requestJSON(_ url: String, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        print("URL = ",url)
        
        Alamofire.request(url).responseJSON
        {
            response in
            switch response.result
            {
            case .success:
                if let data = response.data
                {
                    success(data)
                }
            case .failure(let error):
                failure(error)
                break
            }
        }
    }
    
    
}


func requestGET(_ url: String, params : Parameters?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
{
    
    print("URL = ",url)
    print("Parameter = ",params)
    print("Headers = ",headers)
    
    
    if Connectivity.isConnectedToInternet()
    {
        do
            {
                Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON
                {
                    (response) in
                    
                    print("Response = ",response)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
        catch let JSONError as NSError
        {
            failure(JSONError)
        }
    }
    else
    {
        //            let err = NSError(domain: "Check Internet Connection".localized(), code: nil, userInfo: nil)
        let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : "Check Internet Connection"])
        failure(error)
    }
    
}

