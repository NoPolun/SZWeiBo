//
//  UIBarButton+Extension.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/29.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit
extension UIBarButtonItem
{
    convenience init(imageName:String,target: Any?, action: Selector) {
   
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named:imageName + "_highlighted"), for: UIControlState.highlighted)
            btn.sizeToFit()
      btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView:btn)
        
    }
}
