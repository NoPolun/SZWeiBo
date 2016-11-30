//
//  TitleButton.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/29.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    //    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    //        return CGRect.zero
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    //使用xib时候调用的方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//         setUI()
    }
    private  func setUI(){
        setImage(UIImage(named:"navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: UIControlState.selected)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        sizeToFit()
    }
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title ?? "" + "  ", for: state)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置控件偏移位置
        //        titleLabel?.frame.offsetBy(dx: -(imageView?.frame.width)!, dy: 0)
        //        imageView?.frame.offsetBy(dx: (titleLabel?.frame.width)!, dy: 0)
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.width)!
        
    }
    
}
