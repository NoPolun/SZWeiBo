//
//  SZPresentationControllerManager.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/29.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit


class SZPresentationControllerManager: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
{
    /// 定义标记记录当前是否是展现
   private var isPresent = false
    /// 保存菜单的尺寸
    var presentFrame = CGRect.zero

    
    
    
    //该方法用于返回一个负责转场动画的尺寸的对象
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = SZPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame =  presentFrame
        return pc

    }
    //该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        // 发送一个通知, 告诉调用者状态发生了改变
        NotificationCenter.default.post(name: Notification.Name(SZPresentationManagerDidPresented), object: self)
        return self
        
    }
    //该方法用于返回一个负责转场消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        // 发送一个通知, 告诉调用者状态发生了改变
        // 发送一个通知, 告诉调用者状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SZPresentationManagerDidDismissed), object: self)
        return self
    }
    
    //告诉系统展现和消失的时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 999
    }
    /*专门用于管理modal如何展现和消失的，无论展现还是消失都会调用这个方法
     注意:只要我们实现了这个代理方法，系统将不会再有默认的动画，也就是说默认的modal重下自上的方法不会在帮我们添加了，包括需要展现的视图也需要我们自己添加到容器上(containerView)
     */
    //transitionContext 所有的动画需要的东西都会保存在上下文中，
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            guard   let toVC =  transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
            }
            
            transitionContext.containerView.addSubview(toVC)
            
            toVC.transform = CGAffineTransform(scaleX: 1.0, y: 0.0);
            //设置锚点(只有加上这句话才能形成从上面显现的方式)
            toVC.layer.anchorPoint = CGPoint(x:0.5,y:0.0)
            UIView.animate(withDuration: 0.5, animations: {
                
                toVC.transform = CGAffineTransform.identity
            }) { (_) in
                //注意:自定义转场执行完成之后要告诉系统动画执行完毕
                transitionContext.completeTransition(true)
            }
            
            
        } else {
            // 消失
            // 1.拿到需要消失的视图
            guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else
            {
                return
            }
            // 2.执行动画让视图消失
            UIView.animate(withDuration: 0.5, animations: {
                // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
                fromView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
                
                }, completion: { (_) in
                    // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
                    transitionContext.completeTransition(true)
            })
        }
    }

}
