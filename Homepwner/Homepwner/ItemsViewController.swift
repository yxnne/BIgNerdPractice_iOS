//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/3.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController{ //UITableViewController 类似 listview
    
    
    //数据集
    var itemStore : ItemStore!
    
    var imageStore: ImageStore!
    
    //加上NavigationBar的左边编辑模式 ,只能用这样的情况 ？？
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    //IBAction ：TableHeader上的button
//    @IBAction func addNewItem( _ sender:UIButton){
    //这里要变成 BarButton触发它
        @IBAction func addNewItem( _ sender:UIBarButtonItem){
        //下面是错位的方法，这样会导致，添加UITableView多了一列但是数据并没有多
//        let lastRow = tableView.numberOfRows(inSection: 0)
//        let indexPath = IndexPath(row:lastRow , section:0)
//        //insert this new row into table
//        tableView.insertRows(at: [indexPath], with: .automatic)
        
        let newItem = itemStore.createItem()
        //指出在数据集的哪里,这里是有校验的意思
        if let index = itemStore.allItems.index(of: newItem){
            let indexPath = IndexPath(row:index , section:0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    //toggle 触发的意思,进入编辑模式
    //系统自带的NavigationBar 的 edit 按钮 实现了这种方式
//    @IBAction func toggleEditingMode(_ sender:UIButton){
//        // isEditing 是UITableViewController的一个属性，可以自动关联到UITableView
//        if isEditing{
//            //当前是编辑模式
//            //改变按钮文字
//            sender.setTitle("Edit", for: .normal)
//            
//            //关掉编辑模式
//            setEditing(false, animated: true)
//        } else{
//        
//            //改变按钮文字
//            sender.setTitle("Done", for: .normal)
//            //打开编辑模式 生活 办公 网购 游戏
//            setEditing(true, animated: true)
//        }
//    }
//    
    //implements the protocol Method UITableViewDataSource
    //返回列表项的数量
    //这个接口UITableViewController已经实现了
    //这里的section的意思就是分段，就像电话本里面依照首字母把一个列表分段了一样
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    //放数据
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell  就是 每一条数据的item样式模板
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        //在重用池里面看看有没有便签是UITabViewCell的cell 这个定义在stroyboard里面的prototype cell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UITabViewCell",for:indexPath)
        
        //之前使用了系统模板，现在自定义了
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",for:indexPath) as! ItemCell
        
        
        let item = itemStore.allItems[indexPath.row]
        
//        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
//    //删数据
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        // 确定下操作是删除
//        if editingStyle == .delete{
//            //找到行号对应的对象
//            let item = itemStore.allItems[indexPath.row]
//            //删掉数据集中的对象
//            itemStore.removeItem(item)
//            //对应删除列表视图层
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        
//        }
//    }
    
    //删数据 ，加上了alert 对话框，上面的方法没有对话框
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 确定下操作是删除
        if editingStyle == .delete{
            //找到行号对应的对象
            let item = itemStore.allItems[indexPath.row]
            //创建alert
            let title = "Delete \(item.name)?"
            let message = "Sure that you wanna delete this item???"
            let ac = UIAlertController(title:title,message:message,preferredStyle:.actionSheet)
            //增加alert的action
            //取消action
            let cancelAction = UIAlertAction(title:"Cancel",style:.cancel,handler:nil)
            ac.addAction(cancelAction)
            //删除action
            let deleteAction = UIAlertAction(title:"Delete",style:.destructive,
                handler:{(action)->Void in
                    
                    //删掉数据集中的对象
                    self.itemStore.removeItem(item)
                    //删掉缓存里面对应的图片
                    self.imageStore.deleteImage(forKey: item.itemKey)
                    //对应删除列表视图层
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            //呈现alert
            present(ac, animated: true, completion: nil)
            
            
        }
    }
    
    //挪动数据,又他妈是这个方法的重载方法
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        //得到状态栏的高度
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        //给人家 tableView 添加边距，要不然顶到最上面了
//        let insets = UIEdgeInsets(top:statusBarHeight,left : 0,bottom : 0,right : 0)
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 65
    }
    
    //跳转逻辑
    //segue就是类似Intent
    //一个segue触发后会调用这个方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue携带了一个重要的标识信息
        switch segue.identifier {
        case "showItem"?:
            //print()
            if let row = tableView.indexPathForSelectedRow?.row{
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                
                detailViewController.imageStore = imageStore
            }
            
        default:
            preconditionFailure("Unexception segue identifier")
        }
    }
    
    //当navigationcontroller回去加载这个页面的时候会调用这个方法，你这里需要更新下数据集
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.reloadData()
    }

}
