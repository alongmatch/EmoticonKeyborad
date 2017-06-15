//
//  HMEmoticon.swift
//  Weibo
//
//  Created by teacher on 2017/6/14.
//  Copyright © 2017年 teacher. All rights reserved.
//

import UIKit
//  表情模型
class HMEmoticon: NSObject {
    //  表情描述
    var chs: String?
    //  表情图片名
    var png: String?
    //  表情类型 0: 图片表情，1: emoji表情
    var type: String?
    //  16进制的字符串，显示的时候转emoji表情
    var code: String?
    
    //  图片路径
    var path: String?
}
