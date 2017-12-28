//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by iel-mac on 2017/6/21.
//  Copyright © 2017 iel-mac. All rights reserved.
//

import UIKit

class ConversionViewController:UIViewController ,UITextFieldDelegate{
    
    // 数值转换器
    let numberFormatter : NumberFormatter = {//这是一个匿名函数 闭包 closure
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()

    // UILabel ：摄氏度标签 的 Outlet 声明
    @IBOutlet var celsiusLable:UILabel!
    // 背景View的 Outlet
    @IBOutlet var textField:UITextField!
    
    //var fahrenheiValue:Measurement<UnitTemperature>?
    //属性观察器
    var fahrenheiValue:Measurement<UnitTemperature>?{
        didSet {
            updateCelsiusLabel()
        }
    }
    //这个是属性 直接跟着setget方法
    var celsiusValue:Measurement<UnitTemperature>?{
        if let fahrenheiValue = fahrenheiValue{
            return fahrenheiValue.converted(to: .celsius)
        }else{
            return nil
        }
    }
    
    
    //监听华氏度输入栏的回调
    @IBAction func fahrenheitFieldEditChanged(_ textField :UITextField){
        
//        if let text = textField.text,!text.isEmpty{
//            celsiusLable.text = textField.text
//        }else {
//            celsiusLable.text = "???"
//        }
        
//        if let text = textField.text,let value = Double(text){
//            fahrenheiValue = Measurement(value:value,unit: .fahrenheit)
//        
//        } else {
//            fahrenheiValue = nil
//        }
        
            if let text = textField.text,let number = numberFormatter.number(from:text){
                fahrenheiValue = Measurement(value:number.doubleValue,unit: .fahrenheit)
        
            } else {
                fahrenheiValue = nil
            }
    }
    //写一个回调，当点击背景View的时候收齐键盘
    @IBAction func dismissKeyboard(_ sender:UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    //更新设施度标签的方法
    func updateCelsiusLabel(){
        if let celsiusValue = celsiusValue{
            //celsiusLable.text = "\(celsiusValue.value)"
            celsiusLable.text =
                numberFormatter.string(from:NSNumber(value:celsiusValue.value))
            
        } else {
            celsiusLable.text = "???"
        }
    }

    //重写 viewDidLoad 初始化进入界面
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelsiusLabel()
        
        //这里为了测试lazy loading时候调用该方法
        //在tab切换中，viewDidLoad()调用一次之后并不在调用了
        print("Conversion View Controller loaded")
    }
    
    var count = 0
    //在tab切换中，viewWillAppear()方法调用在每次将view呈现在用户之前
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Conversion View Controller will appear")
        //这里是viewController背景的引用
        //self.view
        if count % 2 == 1{
            self.view.backgroundColor? = UIColor.darkGray
        }else {
            self.view.backgroundColor? = UIColor.lightGray
        }
        count += 1
        
    }
    
    //TextField 控件的代理方法
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("current text: \(String(describing: textField.text))")
        //print("replace text:\(string)")
        //实践检验发现 这里的textField.text 是指变化之前的值 而replacementString 是正在变化的值
        // example -->
        //current text: Optional("") //现在输入框没有值，输入第一个数字2
        //replace text:2
        //current text: Optional("2") //输入第二个数字3
        //replace text:3
        //current text: Optional("23")
        //replace text:3
        
        
//        let exsitingTextHasDecimalSeparator = textField.text?.range(of: ".")
//        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let currentLocale  = Locale.current
        let decimalSeperator = currentLocale.decimalSeparator ?? "."
        
        let exsitingTextHasDecimalSeparator = textField.text?.range(of: decimalSeperator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeperator)
        
        //这里的逻辑是：当已经 存在了一个“.”就不要再弄第二个了
        if exsitingTextHasDecimalSeparator != nil  , //这里逗号就是‘&&’ 就是且的意思？
            replacementTextHasDecimalSeparator != nil{
            return false
        }else{
            return true
        }
        
        //return true
    }
    
}
