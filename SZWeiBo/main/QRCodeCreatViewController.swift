//
//  QRCodeCreatViewController.swift
//  SZWeiBo
//
//  Created by 哲 on 16/11/30.
//  Copyright © 2016年 XSZ. All rights reserved.
//

import UIKit

class QRCodeCreatViewController: UIViewController {

    @IBOutlet weak var customImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       //创建滤镜
        let filter = CIFilter(name:"CIQRCodeGenerator")
        //还原路径默认属性
        filter?.setDefaults()
        //设置需要的生成二维码的数据到滤镜中
        filter?.setValue("https://www.baidu.com".data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        //从滤镜中将生成好的二维码取出
        guard  let ciIMage = filter?.outputImage else {
            return
        }
//        customImageView.image = UIImage.init(ciImage: ciIMage)
         customImageView.image = createNonInterpolatedUIImageFormCIImage(ciIMage, size: 500)
    }

    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }


 }
