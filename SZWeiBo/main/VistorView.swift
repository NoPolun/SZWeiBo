//
//  VistorView.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/28.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit
protocol VistorViewDelegate : NSObjectProtocol
{
    func visitorViewDidClickLoginBtn(visitor:VistorView)
    func visitorViewDidClickRegisterBtn(visitor:VistorView)
}
class VistorView: UIView {
    weak var delegate : VistorViewDelegate?
    //转盘
    @IBOutlet weak var rotationImageView: UIImageView!
    
    //图标
    @IBOutlet weak var iconImageView: UIImageView!
    //文本
    @IBOutlet weak var titleLable: UILabel!
    
    //注册
    @IBOutlet weak var registerButton: UIButton!
    
    //登录
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var icon1ImageView: UIImageView!
    //数据方法
    //imageName图片名称
    //title显示的数据
    func setUpVisitorInfo(imageName:String?,title:String) {
        titleLable.text = title
        guard let name = imageName else {
            //没有图片，首页
            startAnimation()
            return
        }
        //不是首页
        rotationImageView.isHidden = true
        icon1ImageView.image = UIImage(named:name)

    }
    
    private func startAnimation() {
        //创建动画
      let anim =  CABasicAnimation.init(keyPath: "transform.rotation")
        //设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        //默认情况下只要视图消失系统就会移除动画
        anim.isRemovedOnCompletion = false
        //将动画添加到图层上
        rotationImageView.layer.add(anim, forKey: nil)
    }

    class func visitorView()->VistorView {
        return Bundle.main.loadNibNamed("VistorView", owner: nil, options: nil)?.last as! VistorView
    }
    //登录
    @IBAction func loginBtn(_ sender: AnyObject) {
        delegate?.visitorViewDidClickLoginBtn(visitor: self)
    }
    //注册
    @IBAction func registerBtn(_ sender: UIButton) {
        delegate?.visitorViewDidClickRegisterBtn(visitor: self)
    }
    
    
    
}
