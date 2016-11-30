//
//  UIButton+Extension.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/28.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit
extension UIButton
{
    /*
     如果构造方法前面没有convenience单词，代表着是一个初始化构造方法(指定构造方法)
     如果构造方法前面有convenience单词，代表着是一个便利构造方法
     指定构造方法和便利构造方法的区别
     指定构造方法中必须要所有的属性进行初始化
     便利构造方法不用对所有的属性进行初始化，因为便利构造方法一来指定构造方法
    一般情况下如果想给系统的类提供一个快速创建的方法，就自定义一个便利构造方法
     */
    convenience init(imageName:String, imageSelectImage:String,backgroundImage:String) {
        
        self.init()
        
        setImage(UIImage(named:imageName), for: UIControlState.normal)
        setImage(UIImage(named:imageSelectImage), for: UIControlState.selected)
        setBackgroundImage(UIImage(named:backgroundImage), for: UIControlState.normal)
        sizeToFit()
        
    }
    
}
