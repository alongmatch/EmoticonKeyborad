//
//  HMEmticonTools.swift
//  Weibo
//
//  Created by teacher on 2017/6/14.
//  Copyright © 2017年 teacher. All rights reserved.
//

import UIKit
import YYModel

//  每页显示20个表情
private let NumberOfPage = 20

//  表情数据操作工具类
class HMEmoticonTools: NSObject {
    //  单例全局访问点
    static let sharedTools: HMEmoticonTools = HMEmoticonTools()
    
    //  构造函数私有化
    private override init() {
        super.init()
        
        let array = sectionWith(emoticonArray: defaultEmoticonArray)
        let array1 = sectionWith(emoticonArray: emojiEmoticonArray)
        let array2 = sectionWith(emoticonArray: lxhEmoticonArray)
        print(array.count)
        print(array1.count)
        print(array2.count)
    }
    
    //  创建bundle对象
    lazy var emoticonBundle: Bundle = {
        //  获取bundle文件的路径
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
        //  根据path路径创建bundle对象
        let bundle = Bundle(path: path)!
        return bundle
    }()
    
    //  默认表情数据
    private lazy var defaultEmoticonArray: [HMEmoticon] = {
        return self.loadEmoticonArray(folderName: "default", fileName: "info.plist")
    }()
    
    //  emoji表情数据
    private lazy var emojiEmoticonArray: [HMEmoticon] = {
        return self.loadEmoticonArray(folderName: "emoji", fileName: "info.plist")
    }()
    
    //  浪小花表情数据
    private lazy var lxhEmoticonArray: [HMEmoticon] = {
        return self.loadEmoticonArray(folderName: "lxh", fileName: "info.plist")
    }()
    
    //  最近表情数据
    private lazy var recentEmoticonArray: [HMEmoticon] = {
        let emoticonArray = [HMEmoticon]()
        return emoticonArray
    }()
    
    //  准备表情视图(collectionView)的数据源
    lazy var allEmoticonArray: [[[HMEmoticon]]] = {
        let sectionDefaultEmoticonArray: [[HMEmoticon]] = self.sectionWith(emoticonArray: self.defaultEmoticonArray)
        let sectionEmojiEmotionArray: [[HMEmoticon]] = self.sectionWith(emoticonArray: self.emojiEmoticonArray)
        let sectionLxhEmoitonArray: [[HMEmoticon]] = self.sectionWith(emoticonArray: self.lxhEmoticonArray)
        
        return [
                [self.recentEmoticonArray],
                sectionDefaultEmoticonArray,
                sectionEmojiEmotionArray,
                sectionLxhEmoitonArray
        ]
        
    }()
    
    //  根据文件夹和文件名获取对应的表情数据
    func loadEmoticonArray(folderName: String, fileName: String) -> [HMEmoticon] {
        //  会直接把系统bundle里面Contents和Resources这两层文件夹直接透过去
        let path = self.emoticonBundle.path(forResource: "\(folderName)/\(fileName)", ofType: nil)!
        //  获取plist文件数据
        let dicArray = NSArray(contentsOfFile: path) as! [[String: Any]]
        //  使用YYModel把字典数组转成模型数组
        let modelArray = NSArray.yy_modelArray(with: HMEmoticon.self, json: dicArray) as! [HMEmoticon]
        //  遍历模型数组
        for model in modelArray {
            if model.type == "0" {
                //  图片表情，需要设置图片对应的文件名，目的是在加载表情的时候使用
                model.path = folderName + "/" + model.png!
            }
        }
        
        
        return modelArray
    }
    
    //  根据每种表情数据拆分成对应的二维数组，表示显示多少页
    func sectionWith(emoticonArray: [HMEmoticon]) -> [[HMEmoticon]] {
        //  根据表情数组的个数计算页数， 每页最多显示20个表情
        let pageCount = (emoticonArray.count - 1) / NumberOfPage + 1
        
        var tempArray = [[HMEmoticon]]()
        //  遍历页数，截取每页对应表情数组
        for page in 0..<pageCount {
            //  开始截取的索引
            let loc = page * NumberOfPage
            //  截去的长度
            var len = NumberOfPage
            
            if loc + len > emoticonArray.count {
                //  超出范围,截取剩余个数
                len = emoticonArray.count - loc
            }
            
            //  截取子数组
            let subArray = (emoticonArray as NSArray).subarray(with: NSMakeRange(loc, len)) as! [HMEmoticon]
            tempArray.append(subArray)
        }
        return tempArray
    }
    
}
