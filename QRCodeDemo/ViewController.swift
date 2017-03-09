//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by 阮巧华 on 2017/3/9.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var CreateQRCodeBtn: UIButton!
    @IBOutlet weak var QRCodeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createQRCode("Hello World")
        // Do any additional setup after loading the view, typically from a nib.
    }

    func createQRCode(_ string:String) {
        
        let qrImageFilter = CIFilter(name:"CIQRCodeGenerator")
        qrImageFilter?.setDefaults()
        
        let qrImageData = string.data(using: .utf8)
        
        //设置过滤器的 输入值  ,KVC赋值
        qrImageFilter?.setValue(qrImageData, forKey: "inputMessage")
        //取出图片
        var qrImage = qrImageFilter?.outputImage
        
        //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
        qrImage = qrImage?.applying(CGAffineTransform(scaleX: 20,y: 20))
        //转成 UI的 类型
        let qrUIImage = UIImage(ciImage:qrImage!)
        //----------------给 二维码 中间增加一个 自定义图片----------------
        //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
        UIGraphicsBeginImageContext(qrUIImage.size);
        
        //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
        qrUIImage.draw(in: CGRect(x: 0, y: 0, width: qrUIImage.size.width, height: qrUIImage.size.height))
        //获取当前画得的这张图片
        let finalyImage = UIGraphicsGetImageFromCurrentImageContext();
        //关闭图形上下文
        UIGraphicsEndImageContext();
        //设置图片
        self.imageView.image = finalyImage;

    }
    
    @IBAction func CreateQRCodeBtnAction(_ sender: UIButton) {
        
        guard QRCodeTextField.text != "" else {
            return
        }
        createQRCode(QRCodeTextField.text!)

    }
    
    @IBAction func QRCodeImageViewLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let image = imageView.image!
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }

}

