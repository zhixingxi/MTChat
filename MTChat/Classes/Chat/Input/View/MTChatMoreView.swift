//
//  MTChatMoreView.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

// MARK: - 常量
/// 列数
private let kCellcol = 4
/// 行数
private let kCellRow = 2
private let kCellNumberOfOnePage = kCellRow * kCellcol
private let kMoreCellID = "MTChatMoreCell"

// MARK: - Protocol
protocol MTChatMoreViewDelegate: NSObjectProtocol {
    func chatMoreView(moreView: MTChatMoreView, didSelectedType type: MTChatEnums.MoreType)
}

class MTChatMoreView: UIView {
    
    weak var delegate: MTChatMoreViewDelegate?
    
    private var collectionView: UICollectionView!
    
    private var pageControl: UIPageControl!
    
    private var dataSource: [(name: String, icon: UIImage, type: MTChatEnums.MoreType)] = [
        ("照片", UIImage(named: "sharemore_pic")!, .pic),
        ("相机", UIImage(named: "sharemore_video")!, .video),
        ("红包", UIImage(named: "sharemore_wallet")!, .redpacket)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension MTChatMoreView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.contentSize = CGSize(width: MTUIConstant.screenWith, height: collectionView.height)
    }
    
    private func setupViews() {
        setupCollectionVew()
        setupPageControl()
        backgroundColor = MTChatColors.keyboardBgColor
    }
    
    private func setupCollectionVew() {
        let layout = MTChatHorizontalLayout(col: kCellcol, row: kCellRow)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = MTChatColors.keyboardBgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MTChatMoreCell.self, forCellWithReuseIdentifier: kMoreCellID)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.left.top.right.equalToSuperview()
            m.height.equalTo(197)
        }
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect.zero).then({ (pc) in
            pc.numberOfPages = self.dataSource.count / kCellNumberOfOnePage + (self.dataSource.count % kCellNumberOfOnePage == 0 ? 0 : 1)
            pc.currentPage = 0
            pc.pageIndicatorTintColor = UIColor.lightGray
            pc.currentPageIndicatorTintColor = UIColor.gray
            addSubview(pc)
            pc.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalToSuperview()
                m.height.equalTo(35)
            })
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MTChatMoreView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMoreCellID, for: indexPath) as! MTChatMoreCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.item]
        MTLog(model)
        delegate?.chatMoreView(moreView: self, didSelectedType: model.type)
    }
}

extension MTChatMoreView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}
