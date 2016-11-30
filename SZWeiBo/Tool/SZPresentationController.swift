//
//  SZPresentationController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/29.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class SZPresentationController: UIPresentationController {
    /// 保存菜单的尺寸
    var presentFrame = CGRect.zero
   override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    //用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews() {
    
//        containerView  非常重要，容器视图
//        presentedView 非常重要，可以通过该方法拿到弹出的视图
        presentedView?.frame = CGRect.init(x: 100, y: 45, width: 150, height: 200)
        // 添加蒙版
        containerView?.insertSubview(coverButton, at: 0)
        coverButton.addTarget(self, action: #selector(SZPresentationController.coverBtnClick), for: UIControlEvents.touchUpInside)
    }
  
    
    
    // MARK: - 内部控制方法
    @objc private func coverBtnClick()
    {
        //        NJLog(presentedViewController)
        //        NJLog(presentingViewController)
        // 让菜单消失
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var coverButton: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        btn.backgroundColor = UIColor.clear
        return btn
    }()

}
