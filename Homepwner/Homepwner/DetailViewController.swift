//
//  DetailViewController.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/5.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController ,UITextFieldDelegate,
                            UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    //显示照片的
    @IBOutlet var imageView: UIImageView!
    //使用control drag的方式添加的 outlet
    @IBOutlet var nameField: UITextField!

    @IBOutlet var serialNumberField: UITextField!

    @IBOutlet var valueField: UITextField!
    
    @IBOutlet var dataLable: UILabel!
    
    //ImageStore
    var imageStore: ImageStore!
    
//    var item : Item!
    var item : Item!{ // 这里加上这个方法 didset 就是这里设置值后调用的
        didSet{
            navigationItem.title = item.name
        }
    }
    
    //搞两个格式化器
    let numberFomatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    //日期格式化器
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK:so important
    //"MARK" 标签是快速定位一个自己的位置用的
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //string 类型
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        //不是String类型
        valueField.text = numberFomatter.string(from:NSNumber(value:item.valueInDollars))
        dataLable.text = dateFormatter.string(from: item.dateCreated)
        
        //如果缓存中已经关联了图片，那就拿出来，显示
        let key = item.itemKey
        
        let imageToDisplay  = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    //下面这个方法是要被调用的，在NavigationController退回之前
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //隐藏软件胖先
        view.endEditing(true)
        
        //保存这些修改，因为在本页面可以修改的
        item.name = nameField.text ?? ""//nameField.text 要是 nil 那就返回 ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
            let value  = numberFomatter.number(from: valueText){
                item.valueInDollars = value.intValue
            
        }else{
            item.valueInDollars = 0
            
        }
    }
    
    //UITextFieldDelegation协议里面的方法
    //点击软键盘的 return按键的时候要调用这个
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("backgroundTapped")
        view.endEditing(true)
        
    }

    //这是给toolbar 上面的小照相机按钮增加action
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        print("call take pic")
        let imagePicker = UIImagePickerController()
        
        //验证下是否有设备支持
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        //呈现这个imagePicker
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //代理方法 当选择了图片的时候回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //得到图片
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //将图片放到缓存里面
        imageStore.setImage(img, forKey: item.itemKey)
        //放置图片
        imageView.image = img
        //关掉Picker
        dismiss(animated: true, completion: nil)
    }
}
