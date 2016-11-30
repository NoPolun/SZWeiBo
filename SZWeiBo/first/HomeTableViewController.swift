//
//  HomeTableViewController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/26.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    var titleButton = TitleButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            //设置访客视图
            vistorView?.setUpVisitorInfo(imageName: nil, title: "关注一些人，回这里有惊喜")
            return
        }
        //初始化导航条
        setUpNav()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(SZPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(SZPresentationManagerDidDismissed), object: animatorManager)
    }
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    //MARK —添加导航条
    private func setUpNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"navigationbar_friendattention",target:self,action:#selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName:"navigationbar_pop",target:self,action:#selector(HomeTableViewController.rightBtnClick))
        titleButton.addTarget(self, action: #selector(HomeTableViewController.titleBtn), for: UIControlEvents.touchUpInside)
        titleButton.setTitle("首页", for: UIControlState.normal)
        navigationItem.titleView = titleButton
    }
    @objc func leftBtnClick() {
        QL1("点击了左边")
    }
    @objc func rightBtnClick() {
         let rigth = UIStoryboard(name:"QRCodeViewController",bundle:nil)
        guard  let vc = rigth.instantiateInitialViewController()
            else {
            return
        }
        present(vc, animated: true, completion: nil)
        
        
    }
    @objc private func titleChange()
    {
        titleButton.isSelected = !titleButton.isSelected
    }
    
    
    @objc private func  titleBtn(btn:TitleButton){
        let popView = UIStoryboard.init(name:"PopOver", bundle: nil)
        guard  let menuView = popView.instantiateInitialViewController() else {
            return
        }
        //动画代理
        menuView.transitioningDelegate  = animatorManager
        
        //设置转场动画样式
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        //弹出菜单
        present(menuView, animated: true, completion: nil)
        
    }
    // MARK: - 懒加载
    private lazy var animatorManager: SZPresentationControllerManager = {
        let manager = SZPresentationControllerManager()
        manager.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 300)
        return manager
    }()
}
