//
//  ViewController.swift
//  Quiz
//
//  Created by iel-mac on 2017/6/16.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    
    //add for the UIs to outlet reference
    //@IBOutlet var questionLabel:UILabel!
    @IBOutlet var currentQuestionLabel:UILabel!
    @IBOutlet var nextQuestionLabel:UILabel!
    //get constraint 也能加outLet
    @IBOutlet var currentOuestionLabelCenterXConstraint:NSLayoutConstraint!
    @IBOutlet var nextOuestionLabelCenterXConstraint:NSLayoutConstraint!
    
    @IBOutlet var answerLabel:UILabel!
    
    
    // data models
    //Questions
    let questions:[String] = [
        "what is 7 + 7 ??",
        "what is the captital of Vermont ?",
        "what is cognac made from ?"
    ]
    //Answers
    let answers :[String ] = [
        "14",
        "Montpelier",
        "Grapes"
    ]
    
    var currentQuestionIndex:Int = 0
    
    //add  action method to button
    @IBAction func showNextQestion(_ sender:UIButton){
        
        //currentQuestionLabel.text = questions[currentQuestionIndex]
        //这是我的实现动画交换  不好  不如使用 completion
//        currentQuestionLabel.alpha = 1
//        nextQuestionLabel.alpha = 0
        
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count{
            currentQuestionIndex = 0
        
        }
        
        let question:String = questions[currentQuestionIndex]
        
        
        nextQuestionLabel.text = question
        
        answerLabel.text = "???"
        //动画
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_ sender:UIButton){
        let answer:String = answers[currentQuestionIndex]
        answerLabel.text = answer
        
    }
    
    //要增加动画
    func animateLabelTransitions() -> () {
//        //这是闭包的写法
//        let animationClosure = { () -> Void in
//            
//            self.currentQuestionLabel.alpha = 0
//            self.nextQuestionLabel.alpha = 1
//        }
//        //将闭包传递进去
//        UIView.animate(withDuration: 2, animations: animationClosure)
        //self.view.layoutIfNeeded()
        view.layoutIfNeeded()
        
        let screenWidth = view.frame.width
        self.nextOuestionLabelCenterXConstraint.constant = 0
        self.currentOuestionLabelCenterXConstraint.constant += screenWidth
        
//        UIView.animate(withDuration: 1,
//                       delay:0,
//                       options:[.curveEaseInOut],
//                       animations: {
//                            self.currentQuestionLabel.alpha = 0
//                            self.nextQuestionLabel.alpha = 1
//                        
//                            self.view.layoutIfNeeded()
//                        },
//                       completion:{ _ in //这是有一个参数的闭包
//                            swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
//                            swap(&self.currentOuestionLabelCenterXConstraint, &self.nextOuestionLabelCenterXConstraint)
//                            self.updateOffScreenLabel()
//        })
        // Spring Animation
        UIView.animate(withDuration: 1,
                       delay:0,
                       usingSpringWithDamping: 0.3,//阻尼系数
                       initialSpringVelocity: 0,
                       animations: {
                        self.currentQuestionLabel.alpha = 0
                        self.nextQuestionLabel.alpha = 1
                        
                        self.view.layoutIfNeeded()
        },
                       completion:{ _ in //这是有一个参数的闭包
                        swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                        swap(&self.currentOuestionLabelCenterXConstraint, &self.nextOuestionLabelCenterXConstraint)
                        self.updateOffScreenLabel()
        })
        
        
        
    }
    //do some before load the view
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear is called!")
        
        currentQuestionLabel.alpha = 1
        nextQuestionLabel.alpha = 0
    }
    //do some when load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentQuestionLabel.text = questions[currentQuestionIndex]
        
        //偏移动画的初始位置设置
        updateOffScreenLabel()
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextOuestionLabelCenterXConstraint.constant = -screenWidth
    }

}

