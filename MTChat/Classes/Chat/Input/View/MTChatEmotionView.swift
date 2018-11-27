//
//  MTChatEmotionView.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

// MARK: - 常量
private let kCols = 8
private let kRows = 3
private let kNumOfOnePage = kRows * kCols
//private let kEmotionViewHeight: CGFloat = 160.0
private let kEmotionCellID = "MTChatEmotionCell"

// MARK: - protocol
protocol MTChatEmotionViewDelegate: NSObjectProtocol {
    func emotionView(emotionView: MTChatEmotionView, didSelectedEmotion emotion: MTEmotionType)
    func send(emotionView: MTChatEmotionView)
}

class MTChatEmotionView: UIView {
    private lazy var emotions: [MTEmotionType] = {
        return MTEmotionHelp.getAllEmotions()
    }()
    
    var delegate: MTChatEmotionViewDelegate?
    
    private var collectionView: UICollectionView!
    
    private var pageControl: UIPageControl!
    
    private var vBottom: UIView!
    
    private var btSend: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func sendBtnClick(_ sender: UIButton) {
        
    }
    
}

// MARK: - UI
extension MTChatEmotionView {
    
    private func setupViews() {
        setupCollectionVew()
        setupBottom()
        setupPageControl()
    }
    
    private func setupBottom() {
        
        vBottom = UIView().then({ (v) in
            v.backgroundColor = UIColor.white
            addSubview(v)
            v.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalToSuperview()
                m.height.equalTo(38)
            })
        })
        
        btSend = UIButton(type: .custom).then({ (bt) in
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            bt.backgroundColor = UIColor(red:0.13, green:0.41, blue:0.79, alpha:1.00)
            bt.setTitle("发送", for: .normal)
            bt.addTarget(self, action: #selector(sendBtnClick(_:)), for: .touchUpInside)
            vBottom.addSubview(bt)
            bt.snp.makeConstraints({ (m) in
                m.top.right.bottom.equalToSuperview()
                m.width.equalTo(53)
            })
        })
    }
    
    private func setupCollectionVew() {
        let layout = MTChatHorizontalLayout(col: kCols, row: kRows)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = MTChatColors.keyboardBgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MTChatEmotionCell.self, forCellWithReuseIdentifier: kEmotionCellID)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.left.top.right.equalToSuperview()
            m.height.equalTo(160)
        }
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect.zero).then({ (pc) in
            pc.numberOfPages = self.emotions.count / kNumOfOnePage + (self.emotions.count % kNumOfOnePage == 0 ? 0 : 1)
            pc.currentPage = 0
            pc.pageIndicatorTintColor = UIColor.lightGray
            pc.currentPageIndicatorTintColor = UIColor.gray
            pc.backgroundColor = MTChatColors.keyboardBgColor
            addSubview(pc)
            pc.snp.makeConstraints({ (m) in
                m.left.right.equalToSuperview()
                m.top.equalTo(collectionView.snp.bottom).offset(-6)
                m.bottom.equalTo(vBottom.snp.top)
            })
        })
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MTChatEmotionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmotionCellID, for: indexPath) as! MTChatEmotionCell
        cell.emotion = emotions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emotion = emotions[indexPath.item]
        delegate?.emotionView(emotionView: self, didSelectedEmotion: emotion)
    }
    
}

// MARK: - UIScrollViewDelegate
extension MTChatEmotionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}
