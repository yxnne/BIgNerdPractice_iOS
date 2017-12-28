//
//  ImageStore.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/10.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class ImageStore{
    
    //NSCache像一个dictionary,但是当系统不足时会自动释放对象
    //缓存可不是持久化
    let cache = NSCache< NSString ,UIImage >()
    
    func setImage(_ img :UIImage ,forKey key :String ){
        //缓存
        cache.setObject(img, forKey: key as NSString)
        
        //为了持久化
        // 拿到存储路径url
        let url = imageURL(forKey: key)
        // 将img变成JPEG Date
        if let data = UIImageJPEGRepresentation(img, 0.5){
            //写入
            let _ = try? data.write(to: url, options: [.atomic])
        
        }
        
    }
    
    func image(forKey key :String ) -> UIImage?{
        //return cache.object(forKey: key as NSString)
        
        if let exsistingImage = cache.object(forKey: key as NSString){
        
            return exsistingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile:url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
        
    }
    
    func deleteImage(forKey key :String ){
        cache.removeObject(forKey: key as NSString)
        
        //保证在文件系统中也要被删除
        let url = imageURL(forKey: key)
        //这里需要异常捕获
        //FileManager.default.removeItem(at: url)
        do{
            try FileManager.default.removeItem(at: url)
        }catch let deleteError{
            print("Error removing the img:\(deleteError)")
        
        }
    }
    

    //持久化image
    func imageURL(forKey key: String) -> URL{
    
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = documentDirectories.first!
        return documentDir.appendingPathComponent(key)
        
    }

}
