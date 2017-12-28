//
//  ViewController.swift
//  Buggy
//
//  Created by iel-mac on 2017/6/30.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Button :tap me 的事件方法
//    @IBAction func buttonTapped(_ sender:UIButton){
//        print("Called buttonTapped(_:)")
//    }
    
//    @IBAction func buttonTapped_BuggyTest(_ sender:UIButton){
    @IBAction func buttonTapped(_ sender:UIButton){
        print("Called buttonTapped(_:)")
        
        //嘿，试试swift的打印
        print("Method\(#function) in file : \(#file) and, the line No. is：\(#line)" )
        
//        
//        // Log the sender
//        print("sender? \(sender)")
//        // Log the control state
//        print("Is Control On? \(sender.isOn)")
        
        badMethod()
        
    }
    func badMethod(){
        let arrary  = NSMutableArray()
        
        for i in 0..<10{
            print("\(i)")
            arrary.insert(i, at: i)
        }
        
        for _ in 0..<10{
        
            arrary.remove(at:0)
        }

    }
    
}
