//
//  MainViewController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/26.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         tabBar.addSubview(conposeButton)
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: tabBar.bounds.height)
        conposeButton.frame =  CGRect.init(x: 2 * width, y: 0, width: width, height:rect.height)
//        conposeButton.frame = rect.offsetBy(dx: width * 2, dy: 0)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orange
        addChildViewControllers()
       
        conposeButton.center = tabBar.center
    }
    func addChildViewControllers() {
        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            QL1("文件不存在")
            return
        }
        guard let data = NSData.init(contentsOfFile: filePath) else {
            QL1("加载二进制数据失败")
            return
        }
        do {
            let objc = try  JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as![[String:AnyObject]]
            for dict in objc {
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(childControllerName: vcName, title: title, imageName: imageName)
                
            }
        }catch
        {
            addChildViewController(childControllerName: "FirstTableViewController", title: "首页", imageName:"tabbar_home")
            addChildViewController(childControllerName: "SecondTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController(childControllerName: "NullViewController", title: "", imageName: "")
            addChildViewController(childControllerName: "ThirdTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController(childControllerName: "FourTableViewController", title: "我", imageName: "tabbar_profile")
        }
    }
    
    func addChildViewController(childControllerName: String?,title :String?, imageName: String?) {
        
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            QL1("获取失败")
            return
        }
        var cls:AnyClass? = nil
        if let vcName = childControllerName {
            cls = NSClassFromString(name + "." + vcName)
        }
        guard  let  typeCls = cls as? UITableViewController.Type else {
            QL1("class不能当做tableviewcontroller")
            return
        }
        let childController = typeCls.init()
        childController.title = title
        if let ivName = imageName {
            childController.tabBarItem.image = UIImage(named:ivName)
            childController.tabBarItem.selectedImage = UIImage(named:ivName + "_highlighted")
        }
        let nav = UINavigationController.init(rootViewController: childController)
        addChildViewController(nav)
    }
    //MARK: - 懒加载
    lazy var conposeButton :UIButton = {
        ()-> UIButton in
        let btn = UIButton(imageName:"tabbar_compose_icon_add", imageSelectImage:"tabbar_compose_icon_add_highlighted",backgroundImage:"tabbar_compose_button_highlighted")

            btn.addTarget(self, action:#selector(MainViewController.compseBtnClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    //private为防止其他页面调用，私有化处理
    //如果是自定义之后要实现OC的动态派发就要添加@objc 否则就去掉private
   @objc private func compseBtnClick() {
        QL1("执行点击方法，如果不行执行这个，执行系统的tableview方法将button添加的位置更改")
    }
    
}
