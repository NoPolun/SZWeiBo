//
//  QRCodeViewController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/29.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit
import AVFoundation
class QRCodeViewController: UIViewController {
    //冲击波视图
    @IBOutlet weak var scanLineImageView: UIImageView!
    //容器视图
    @IBOutlet weak var customContainerView: UIView!
    //冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //视图高度的约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var customLabel: UILabel!
    
    @IBOutlet weak var customTabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置默认选择
        customTabbar.selectedItem = customTabbar.items?.first
        //添加监听，监听工具条的点击
        customTabbar.delegate = self
        //开始扫描二维码
        scanQPCode()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
      
    }
    
    func startAnimation() {
        //设置冲击波
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        //执行扫描动画
        UIView.animate(withDuration: 2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func personBtnClick(_ sender: AnyObject) {
    }

    func scanQPCode(){
        // 判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        //添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        //设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //设置监听监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
       
        // 添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        // 开始扫描
        session.startRunning()
    }
    
    @IBAction func colseBtnClick(_ sender: AnyObject) {
        //移除动画
        scanLineImageView.layer.removeAllAnimations()
        dismiss(animated: true, completion: nil)
        
    }
    //MARK -打开相册
    @IBAction func photoBtnClick(_ sender: AnyObject) {
        //能否发开相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            return
        }
        //创建相册控制器
        let imagePickVC = UIImagePickerController()
        imagePickVC.delegate = self
        //弹出相册控制器
        present(imagePickVC, animated: true, completion: nil)
    }
    //MARK -懒加载
    // MARK: - 懒加载
    /// 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    /// 会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    
    /// 输出对象
    fileprivate lazy var output: AVCaptureMetadataOutput = {
        //设置输入对象解析数据时候感兴趣的范围
        //默认值为CGRect.init(x: 0, y: 0, width: 1, height: 1)
        //通过对值得观察，传入值是比例
            let out = AVCaptureMetadataOutput()
                out.rectOfInterest = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        // 1.获取屏幕的frame
        let viewRect = self.view.frame
        // 2.获取扫描容器的frame
        let containerRect = self.customContainerView.frame
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        

          return out
    }()
    /// 预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    /// 专门用于保存描边的图层
    fileprivate lazy var containerLayer: CALayer = CALayer()
    
}
extension QRCodeViewController:UITabBarDelegate
{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //根据选中的按钮重新选择二维码的高度
        containerHeightCons.constant = (item.tag == 1) ? 100 :200
         view.layoutIfNeeded()
        //移除动画
        scanLineImageView.layer.removeAllAnimations()
        //重新开启动画
        startAnimation()

    }
}
extension QRCodeViewController : AVCaptureMetadataOutputObjectsDelegate
{
    /// 只要扫描到结果就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        customLabel.text =  (metadataObjects.last as AnyObject).stringValue
          clearLayers()
        //将预览图层转换为我们能识别的类型
     let objc = previewLayer.transformedMetadataObject(for: metadataObjects.last as! AVMetadataObject!)
        //对扫描到的二维码描边
       drawLines(objc: objc as! AVMetadataMachineReadableCodeObject)

        
    }
    private func drawLines(objc: AVMetadataMachineReadableCodeObject){
        // 0.安全校验
        guard let array = objc.corners else
        {
            return
        }

    //创建图层，用于保存绘制的矩形
     let layer = CAShapeLayer()
        layer.lineWidth = 2.0
        //线段颜色
        layer.strokeColor = UIColor.green.cgColor
        //填充颜色
        layer.fillColor = UIColor.clear.cgColor
        //创建UIbezierPath,绘制矩形
    let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        point.x = (array[index] as! Dictionary)["X"]!
        point.y = (array[index] as! Dictionary)["Y"]!
        path.move(to: point)
        
        index += 1
        while index < array.count{
            point.x = (array[index] as! Dictionary)["X"]!
            point.y = (array[index] as! Dictionary)["Y"]!
            index += 1
            path.addLine(to: point)
        }
        // 关闭路径
        path.close()
        layer.path = path.cgPath
        // 将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
        /// 清空描边
    }
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }


}
extension QRCodeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //取出选中图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }

        guard let ciImage = CIImage(image: image) else
        {
            return
        }
        // 从选中的图片中读取二维码数据
        // 创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 利用探测器探测数据
        let results = detector?.features(in: ciImage)
        // 取出探测到的数据
        for result in results!
        {
            QL1((result as! CIQRCodeFeature).messageString)
        }
        //
        picker.dismiss(animated: true, completion: nil)
    }
  
}
