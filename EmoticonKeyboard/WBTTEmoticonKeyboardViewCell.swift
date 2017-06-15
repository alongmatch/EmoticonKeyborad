//
//  WBTTEmoticonKeyboardViewCell.swift
//  weibo01
//
//  Created by sumshile on 2017/6/15.
//  Copyright © 2017年 sumshile. All rights reserved.
//

import UIKit

class WBTTEmoticonKeyboardViewCell: UICollectionViewCell {
    private var emoticonButtonArray: [UIButton] = [UIButton]()
    var indexPath: IndexPath?
    //  MARK:   --懒加载控件
    
    var emoticonArray: [WBTTEmoticon]? {
        didSet{
            guard let currentEmoticonArray = emoticonArray else {
                return
            }
            for button in emoticonButtonArray {
                button.isHidden = true
            }
            for (i,emoticon) in currentEmoticonArray.enumerated() {
                let button = emoticonButtonArray[i]
                button.isHidden = false
                if emoticon.type == "0" {
                    let image = UIImage(named: emoticon.path!, in: WBTTEmoticonTools.sharedTools.emoticonBundle, compatibleWith: nil)
                    button.setImage(image, for: .normal)
                    button.setTitle(nil, for: .normal)
                }else{
                    let emoji = (emoticon.code! as NSString).emoji()
                    button.setTitle(emoji, for: .normal)
                    button.setImage(nil, for: .normal)
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        addChildButton()
    }
    private func addChildButton() {
        let buttonWith = width/7
        let butttonHeight = height/3
        for i in 0..<20 {
            let colIndex = i % 7
            let rowIndex = i / 7
            let button = UIButton()
            button.x = CGFloat(colIndex) * buttonWith
            button.y = CGFloat(rowIndex) * butttonHeight
            button.size = CGSize(width: buttonWith, height: buttonWith)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 33)
            contentView.addSubview(button)
            emoticonButtonArray.append(button)
        }
    }
}
