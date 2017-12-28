//
//  ItemStore.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/3.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class ItemStore{
    //所有条目
    var allItems = [Item]()
    
    //序列化的路径保存,使用一个闭包去获得到URL
    let itemArchieveURL :URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
        let documentDir = documentsDirectories.first!
        return documentDir.appendingPathComponent("items.archive")
    }()
    
    //向文件写入数据
    func saveChanges() ->Bool{
        print("write to the sandbox-->\(itemArchieveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchieveURL.path)
    }
    
    /**
     @discardableResult 意思是 你调用函数的时候 用不用返回值随便去
     */
    @discardableResult func createItem() -> Item{
        let newItem = Item(random:true)
        allItems.append(newItem)
        
        return newItem
    }
    
    //构造器
    //构造那么几个
    init() {
//        for _ in 0..<5 {
//            createItem()
//        }
        if let archivedItem = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchieveURL.path) as? [Item]{
            allItems = archivedItem
        }
        
        
    }
    // remove 
    func removeItem(_ item : Item){
        if let index = allItems.index(of: item){
            allItems.remove(at: index)
        }
    }
    //re-insert
    func moveItem(from fromIndex : Int , to toIndex : Int){
        if fromIndex == toIndex{
            return
        }
        
        //得到要挪动那个对象
        let  movedItem = allItems[fromIndex]
        
        //删掉先
        
        allItems.remove(at: fromIndex)
        
        allItems.insert(movedItem, at: toIndex)
        
        
    }
    
    
}
