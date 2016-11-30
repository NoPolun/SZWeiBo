//
//  OAuthViewController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/30.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController{

    /// 网页容器
   
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.定义字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
        // 2.创建URL
        guard let url = URL(string: urlStr) else
        {
            return
        }
        // 3.创建Request
        let request = URLRequest(url: url)
        
        // 4.加载登录界面
        customWebView.loadRequest(request)
        customWebView.delegate = self
    }
    
}

extension OAuthViewController: UIWebViewDelegate
{
    // 该方法每次请求都会调用
    // 如果返回false代表不允许请求, 如果返回true代表允许请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
             // 1.判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else
        {
            return false
        }
        if !urlStr.hasPrefix(WB_Redirect_uri)
        {
            QL1("不是授权回调页面")
            return true
        }
        
        QL1("是授权回调页面")
        // 2.判断授权回调地址中是否包含code=
        // URL的query属性是专门用于获取URL中的参数的, 可以获取URL中?后面的所有内容
        let key = "code="
        guard let str = request.url!.query else
        {
            return false
        }
        
        if str.hasPrefix(key)
        {
            let code = str.substring(from: key.endIndex)
            loadAccessToken(code)
            return false
        }
        QL1("授权失败")
        return false
    }
    
    /// 利用RequestToken换取AccessToken
    fileprivate func loadAccessToken(_ codeStr: String?)
    {
        guard let code = codeStr else
        {
            return
        }
        // 注意:redirect_uri必须和开发中平台中填写的一模一样
        // 1.准备请求路径
        let path = "oauth2/access_token"
        // 2.准备请求参数
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        // 3.发送POST请求
        
        NetWorkTools.shareInstance.post(path, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, objc:Any?) in
             let account = UserAccount(dict: objc as! [String : AnyObject])
            account.saveAccount()

//            self.dismiss(animated: true, completion: nil)
        }) { (task :URLSessionDataTask?, error:Error) in
            
           
            QL1(error)
        }
        
        
        
        
        
        
    }
      

   

}
