//
//  WBTTEmoticonKeyboardView.swift
//  weibo01
//
//  Created by sumshile on 2017/6/14.
//  Copyright © 2017年 sumshile. All rights reserved.
//

import UIKit

class WBTTEmoticonKeyboardView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var toolBar: WBTTEmoticonKeyboardToolBar = {
        let bar = WBTTEmoticonKeyboardToolBar()
        return bar
    }()
    fileprivate lazy var pageControl: UIPageControl = {
        let pageCtr = UIPageControl()
        pageCtr.setValue(UIImage(named: "compose_keyboard_dot_selected")!, forKey: "_currentPageImage")
        //  设置没有选中页的图片
        pageCtr.setValue(UIImage(named: "compose_keyboard_dot_normal")!, forKey: "_pageImage")
        
        //  隐藏单页
        pageCtr.hidesForSinglePage = true
        return pageCtr
    }()
    fileprivate lazy var collection: UICollectionView = {
        //  表情视图的fame
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: self.width, height: self.height - 35))
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        //  设置item的大小
        flowLayout.itemSize = collectionView.size
        //  设置cell之间的最小间距
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //  设置滚动方向
        flowLayout.scrollDirection = .horizontal
        //  开启分页
        collectionView.isPagingEnabled = true
        //  取消弹簧效果
        collectionView.bounces = false
        //  隐藏水平和垂直方向的滚动条
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        //  设置背景色
        collectionView.backgroundColor = self.backgroundColor
        //  设置数据源代理
        collectionView.dataSource = self
        //  设置代理
        collectionView.delegate = self
        
        return collectionView
    }()
    private func setupUI(){
        addSubview(collection)
        self.addSubview(toolBar)
        addSubview(pageControl)
        addToolBar()
        addCollectionView()
    }
    func setPageControlData(indexPath: IndexPath) {
        pageControl.numberOfPages = WBTTEmoticonTools.sharedTools.allEmoticonArray[indexPath.section].count
        pageControl.currentPage = indexPath.item
    }
    private func addCollectionView(){
        let normalIndexPath = IndexPath(item: 0, section: 1)
        collection.scrollToItem(at: normalIndexPath, at: [], animated: false)
        setPageControlData(indexPath: normalIndexPath)
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: collection, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 10))
        collection.register(WBTTEmoticonKeyboardViewCell.self, forCellWithReuseIdentifier: "emoticon")
    }
    private func addToolBar() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 35))
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        toolBar.emoticonButtonCallBack = { [unowned self] (type: EmoticonKeyboardToolBarType) in
            let indexPath: IndexPath
            switch type {
            case .recent:
                print("最近")
                indexPath = IndexPath(item: 0, section: 0)
            case .normal:
                print("默认")
                indexPath = IndexPath(item: 0, section: 1)
            case .emoji:
                print("Emoji")
                indexPath = IndexPath(item: 0, section: 2)
            case .lxh:
                print("浪小花")
                indexPath = IndexPath(item: 0, section: 3)
            }
            //  滚动到指定indexPath
            self.collection.scrollToItem(at: indexPath, at: [], animated: false)
        }
    }
}
extension WBTTEmoticonKeyboardView{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WBTTEmoticonTools.sharedTools.allEmoticonArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WBTTEmoticonTools.sharedTools.allEmoticonArray[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "emoticon", for: indexPath) as! WBTTEmoticonKeyboardViewCell
        cell.emoticonArray = WBTTEmoticonTools.sharedTools.allEmoticonArray[indexPath.section][indexPath.item]
        cell.indexPath = indexPath
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentCenterX = scrollView.contentOffset.x + scrollView.width * 0.5
        let contentCenterY = scrollView.contentOffset.y + scrollView.height * 0.5
        let contentCenter = CGPoint(x: contentCenterX, y: contentCenterY)
        //  根据中心点获取cell对应的indexPath
        if let indexPath = collection.indexPathForItem(at: contentCenter) {
            //  获取indexPath对应的section
            let section = indexPath.section
            //  根据section选中对应的按钮
            toolBar.selectedButtonWithSection(section: section)
            
            setPageControlData(indexPath: indexPath)
        }
    }
}
