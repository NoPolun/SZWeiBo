//
//  BaseTableViewController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/28.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VistorViewDelegate {

    /// 定义标记记录用户登录状态
    var isLogin = UserAccount.isLogin()

    var vistorView : VistorView?
		  
    override func loadView() {

        //判断用户是否登录，登录了显示tableview，没有登录显示登录界面
        isLogin ? super.loadView() : setupVistorView()
    }
    //MARK: - 内部控件
    private func setupVistorView()
    {
         vistorView = VistorView.visitorView()
        vistorView?.backgroundColor = UIColor(white:233/255.0, alpha:1)
        view = vistorView
        vistorView?.delegate = self
        
        // 2.设置代理
        vistorView?.loginButton.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick(_:)), for: UIControlEvents.touchUpInside)
        vistorView?.registerButton.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick(_:)), for: UIControlEvents.touchUpInside)

        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    /// 监听登录按钮点击
    @objc fileprivate func loginBtnClick(_ btn: UIButton)
    {
        // 1.创建登录界面
        let sb = UIStoryboard(name: "OAuthViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        // 2.弹出登录界面
        present(vc, animated: true, completion: nil)
    }
    /// 监听注册按钮点击
    @objc fileprivate func registerBtnClick(_ btn: UIButton)
    {
        QL1("")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
        func visitorViewDidClickLoginBtn(visitor:VistorView)
        {
    
        }
        func visitorViewDidClickRegisterBtn(visitor:VistorView)
        {
            
        }
}

//extension BaseTableViewController:VistorViewDelegate
//{
//    func visitorViewDidClickLoginBtn(visitor:VistorView)
//    {
//        
//    }
//    func visitorViewDidClickRegisterBtn(visitor:VistorView)
//    {
//        
//    }
//}

