//
//  XHNetworkTools.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum ErrorType {
    case timeOut      // 网络超时
    case networkError // 网络错误
    case cancel       // 网络请求取消
}

class XHNetworkTools {

    static let instance = XHNetworkTools()
    
    private var manager: SessionManager
    
    private init() {
        manager = XHNetworkTools.getAlamofireManager()
        
    }
    
    private let httpHeaders: HTTPHeaders = [
        "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
        "Accept": "application/json"
    ]
    
    private class func getAlamofireManager() -> SessionManager  {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10 // seconds
        configuration.timeoutIntervalForRequest = 10  // seconds
//        configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        configuration.httpAdditionalHeaders?.updateValue("Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==", forKey: "Authorization")
        
        let alamofireManager = Alamofire.SessionManager(configuration: configuration)
        
//        alamofireManager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/html", "text/plain") as? Set<String>
        return alamofireManager
    }

    // GET
    func requestGETURL(_ strURL: String, headers: HTTPHeaders? = nil, failure:@escaping (ErrorType ,Error) -> Void, success:@escaping (Any) -> Void) -> DataRequest {
        
        let netManager = manager.request(strURL,method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                success(responseObject.result.value!)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                if error._code == NSURLErrorTimedOut {
                    failure(.timeOut, error)
                } else if error._code == NSURLErrorCancelled {
                    failure(.cancel, error)
                } else {
                    failure(.networkError ,error)
                }
            }
        }
        
        return netManager
    }

    // POST、PUT
    func requestPOSTURL(_ strURL : String, type: String? = "POST", headers: HTTPHeaders? = nil, params : [String : Any]?, failure:@escaping (ErrorType ,Error) -> Void, success:@escaping (Any) -> Void) -> DataRequest {
        
        let netManager = manager.request(strURL, method: HTTPMethod(rawValue: type!)!, parameters: params, encoding: URLEncoding.default,headers: headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                success(responseObject.result.value!)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                if error._code == NSURLErrorTimedOut {
                    failure(.timeOut, error)
                } else if error._code == NSURLErrorCancelled {
                    failure(.cancel, error)
                } else {
                    failure(.networkError ,error)
                }
            }
        }
        
        return netManager
    }

    //MARK: - 照片上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    func upLoadImageRequest(urlString : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //666多张图片上传
                let flag = params["flag"]
                let userId = params["userId"]
                
                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "upload", fileName: name[i], mimeType: "image/png")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
//                            let json = JSON(value)
                        }
                    }
                case .failure(let encodingError):
                    failture(encodingError)
                }
        }
        )
    }
}
