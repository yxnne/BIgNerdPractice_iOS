//
//  DrawView.swift
//  TouchTracker
//
//  Created by iel-mac on 2017/7/13.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class  DrawView: UIView ,UIGestureRecognizerDelegate{
    
//    var currentLine:Line?
    //上面只是是支持一个触摸，现在为了支持多个触摸，把这个变量类型改成字典类型dictionary
    var currentLines = [NSValue : Line ]()
    var finishedLines = [Line]()
    var selectedLineIndex:Int? {
        didSet{
            if selectedLineIndex == nil{
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    
    //拖拽感应器
    var moveRecongnizer :UIPanGestureRecognizer!
    
    //@IBInspectable 使这些量可以在storyBuilder的InterfaceBuilder 的attributes inspector显示出来
    @IBInspectable var finishedLineColor:UIColor = UIColor.black{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor:UIColor = UIColor.red{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineThickness:CGFloat = 10{
        didSet{
            setNeedsDisplay()
        }
    
    }
    
    
    //根据line画线
    func stroke(_ line:Line){
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    
    }
    
    //画线
    override func draw(_ rect: CGRect) {
        //画完的线搞成黑色
        //UIColor.black.setStroke()
        finishedLineColor.setStroke()
        for line in finishedLines{
            stroke(line)
        }
        
        //正在画的弄成红色
//        if let line = currentLine{
//            UIColor.red.setStroke()
//            stroke(line)
//        }
        
        //上述是支持一个触摸点的
        //现在变成支持多点触摸
        //UIColor.red.setStroke()
        currentLineColor.setStroke()
        for ( _ , line) in currentLines{
            stroke(line)
        }
        
        // 画出选中的线用绿色表示
        if let index = selectedLineIndex{
            UIColor.green.setStroke()
            let selectLine = finishedLines[index]
            stroke(selectLine)
        
        }
        
        
    }
    
    //当一个触摸开始的时候，创造一个line
    //这个line的起点和终点都是触摸点
    override func  touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        let touch = touches.first!
//        //得到touch的位置
//        let location = touch.location(in: self)
//        
//        currentLine = Line(begin:location,end:location)
        
        //上述是支持一个触摸点的
        //现在变成支持多点触摸
        
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin:location,end:location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        
        }
        
        setNeedsDisplay()
        
    }
    
    //当一个触摸移动时，更新line的结束点
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        
//        currentLine?.end = location
        
        //上述是支持一个触摸点的
        //现在变成支持多点触摸
        
        print(#function)
        
        for touch in touches{
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if var line = currentLine{
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//            
//            finishedLines.append(line)
//        }
//        
//        currentLine = nil
        
        //上述是支持一个触摸点的
        //现在变成支持多点触摸
        
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject:touch)
            if var line = currentLines[key]{
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
    
    //在这个里面添加一个手势识别器
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //双击手势识别器（双击删除）
        let doubleTapRecongnizer = UITapGestureRecognizer(
            target:self, action:#selector(DrawView.doubleTap(_:))
        )
        doubleTapRecongnizer.numberOfTapsRequired = 2
        doubleTapRecongnizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecongnizer)
        
        //轻点手势识别器
        let tapRecognizer =
            UITapGestureRecognizer(target:self, action:#selector(DrawView.tap(_:))
        )
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecongnizer)//这句的意思就是让双击先判断
        addGestureRecognizer(tapRecognizer)
        
        //长按识别器
        let longPressRecongnizer = UILongPressGestureRecognizer(
            target:self,action:#selector(DrawView.longPress(_:))
        )
        addGestureRecognizer(longPressRecongnizer)
        
        //拖拽识别
        moveRecongnizer = UIPanGestureRecognizer(
            target:self,action:#selector(DrawView.moveLine(_:))
        )
        moveRecongnizer.delegate = self
        moveRecongnizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecongnizer)
        
    }
    
    //双击 手势识别器的回调,注意这个参数
    func doubleTap(_ gestureRecongnizer :UITapGestureRecognizer){
        print("Recognized a double tap")
        
        currentLines.removeAll()
        finishedLines.removeAll()
        selectedLineIndex = nil
        setNeedsDisplay()
    }
    
    //单点 手势识别器的回调,注意这个参数
    func tap(_ gestureRecongnizer :UITapGestureRecognizer){
        print("Recognized a tap")
        
        let point = gestureRecongnizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        //这里加上一个 menuController
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            //使当前View 变成 First Responder
            becomeFirstResponder()
            
            //创建选项
            let deleteItem = UIMenuItem(
                title:"Delete",action:#selector(DrawView.deleteLine(_:))
            )
            
            menu.menuItems = [deleteItem]
        
            //呈现这个menu的地方
            let targetRect = CGRect(
                x:point.x , y:point.y , width:2 , height:2
            )
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        }else{
             menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    //判断点击的点是否是某一个存在的线
    func indexOfLine(at point:CGPoint) -> Int?{
        
        //找到那个线
        for (index , line ) in finishedLines.enumerated(){
            let begin = line.begin
            let end = line.end
            
            //检查线上的点
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05){
                let x = begin.x + ( (end.x - begin.x) * t)
                let y = begin.y + ( (end.y - begin.y) * t)
            
                if hypot(x - point.x, y - point.y) < 20.0{
                    return index
                }
            }
        
        }
        return nil
    }
    //自定义控件想变成 firstResponder必须要重写下这个属性
    override var canBecomeFirstResponder: Bool{ return true }
    
    //删除线的方法
    func deleteLine(_ sender : UIMenuController) {
        
        if let index = selectedLineIndex{
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            setNeedsDisplay()
        }
    }
    //长按的方法
    func longPress(_ gestureRecongnizer:UIGestureRecognizer){
        
        if gestureRecongnizer.state == .began{
            print("Recongnize a Long Press -- begin")
            let point = gestureRecongnizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil{
                currentLines.removeAll()
            }
            
        } else if gestureRecongnizer.state == .ended{
            print("Recongnize a Long Press -- end")
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    
    }
    
    //移动的方法
    func moveLine(_ gestureRecongnizer:UIPanGestureRecognizer){
        print("Recongnized a pan ")
        if let index = selectedLineIndex{
            
            //“pan”(拖拽) 移动了多远？这是一个偏移量
            let translation = gestureRecongnizer.translation(in: self)
            
            //当前线的位置加上移动值
            finishedLines[index].begin.x += translation.x
            finishedLines[index].begin.y += translation.y
            finishedLines[index].end.x += translation.x
            finishedLines[index].end.y += translation.y
            //不要重复加
            gestureRecongnizer.setTranslation(CGPoint.zero, in: self)
            
            //刷新
            setNeedsDisplay()
        }else{
            return
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
