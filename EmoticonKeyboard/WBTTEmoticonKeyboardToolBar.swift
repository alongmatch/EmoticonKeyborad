//
//  WBTTEmoticonKeyboardToolBar.swift
//  weibo01
//
//  Created by sumshile on 2017/6/14.
//  Copyright © 2017年 sumshile. All rights reserved.
//

import UIKit
enum EmoticonKeyboardToolBarType: Int {
    //  最近
    case recent = 1000
    //  默认
    case normal = 1001
    //  emoji
    case emoji = 1002
    //  浪小花
    case lxh = 1003
}
class WBTTEmoticonKeyboardToolBar: UIStackView {
    var emoticonButtonCallBack: ((EmoticonKeyboardToolBarType)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private var lastSelectedButton: UIButton?
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        self.axis = .horizontal
        self.distribution = .fillEqually
        addChildrenButton(title: "最近", imageName: "compose_emotion_table_left", type: .recent)
        addChildrenButton(title: "默认", imageName: "compose_emotion_table_left", type: .normal)
        addChildrenButton(title: "Emoji", imageName: "compose_emotion_table_left", type: .emoji)
        addChildrenButton(title: "小花", imageName: "compose_emotion_table_left", type: .lxh)
    }
    private func addChildrenButton(title:String,imageName:String,type:EmoticonKeyboardToolBarType)->() {
        let button = UIButton()
        button.tag = type.rawValue
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named:imageName + "_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named:imageName + "_selected"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .selected)
        button.adjustsImageWhenHighlighted = false
        addArrangedSubview(button)
        if type == .normal {
            button.isSelected = true
            lastSelectedButton = button
        }
        
    }
    @objc private func buttonAction(btn:UIButton)->(){
        if btn == lastSelectedButton {
            return
        }
        lastSelectedButton?.isSelected = false
        btn.isSelected = true
        lastSelectedButton = btn
        let type = EmoticonKeyboardToolBarType(rawValue: btn.tag)
        emoticonButtonCallBack!(type!)
    }
    func selectedButtonWithSection(section: Int) {
        //  根据tag获取对应的子视图
        //  如果tag是0，获取的视图不是子视图，是当前视图自己
        //  注意点: 设置视图的tag的是不建议设置为0
        let button = self.viewWithTag(section + 1000) as! UIButton
        //  判断选中的按钮和上一次选中的按钮是否相同，相同直接返回
        if button == lastSelectedButton {
            return
        }
        
        lastSelectedButton?.isSelected = false
        button.isSelected = true
        lastSelectedButton = button
    }
    
}
