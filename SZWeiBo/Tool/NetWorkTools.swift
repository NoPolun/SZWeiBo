//
//  NetWorkTools.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/30.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit
import AFNetworking

// Swift的枚举支持任意数据类型,不需要,分隔
enum SZHTTPMethod{
    case GET
    case POST
}


class NetWorkTools: AFHTTPSessionManager {
    //swift推荐的单例样式
    static let shareInstance :NetWorkTools =
        {
            let baseURL = NSURL(string:"https://api.weibo.com/")
            let instance = NetWorkTools(baseURL: baseURL as URL?, sessionConfiguration: URLSessionConfiguration.default)
             instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set
            return instance
    
    }()
//    // MARK:- get请求
//    func getWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
//        
//        var i = 0
//        var address = path
//        if let paras = paras {
//            
//            for (key,value) in paras {
//                
//                if i == 0 {
//                    
//                    address += "?\(key)=\(value)"
//                }else {
//                    
//                    address += "&\(key)=\(value)"
//                }
//                
//                i += 1
//            }
//        }
//        
//        let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
//        
//        let session = URLSession.shared
//        
//        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
//            
//            if let data = data {
//                
//                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
//                    
//                    success(result)
//                }
//            }else {
//                
//                failure(error!)
//            }
//        }
//        dataTask.resume()
//    }
//    
//    
//    // MARK:- post请求
//    func postWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
//        
//        var i = 0
//        var address: String = ""
//        
//        if let paras = paras {
//            
//            for (key,value) in paras {
//                
//                if i == 0 {
//                    
//                    address += "\(key)=\(value)"
//                }else {
//                    
//                    address += "&\(key)=\(value)"
//                }
//                
//                i += 1
//            }
//        }
//        let url = URL(string: path)
//        var request = URLRequest.init(url: url!)
//        request.httpMethod = "POST"
//        print(address)
//        request.httpBody = address.data(using: .utf8)
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request) { (data, respond, error) in
//            
//            if let data = data {
//                
//                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    
//                    success(result)
//                }
//                
//            }else {
//                failure(error!)
//            }
//        }
//        dataTask.resume()
//    }
//  
}
