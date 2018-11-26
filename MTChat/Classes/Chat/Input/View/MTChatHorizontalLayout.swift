//
//  MTChatHorizontalLayout.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//  Collectionview 横向布局

import UIKit

class MTChatHorizontalLayout: UICollectionViewFlowLayout {
    
    private var attributesArr: [UICollectionViewLayoutAttributes] = []
    
    private var col: Int = 0
    private var row: Int = 0

    init(col: Int, row: Int) {
        super.init()
        self.col = col
        self.row = row
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 重新布局
    override func prepare() {
        super.prepare()
        let itemWH = (MTUIConstant.screenWith / CGFloat(col))
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = true
        let insertMargin = (collectionView!.bounds.height - CGFloat(row) * itemWH) * 0.5
        collectionView?.contentInset = UIEdgeInsets(top: insertMargin, left: 0, bottom: insertMargin, right: 0)
        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            page = itemIndex / (col * row)
            let x = itemSize.width * CGFloat(itemIndex % Int(col)) + (CGFloat(page) * MTUIConstant.screenWith)
            let y = itemSize.height * CGFloat((itemIndex - page * row * col) / col)
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来
            attributesArr.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        return rectAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        let size: CGSize = super.collectionViewContentSize
        let collectionViewWidth: CGFloat = self.collectionView!.frame.size.width
        let nbOfScreen: Int = Int(ceil(size.width / collectionViewWidth))
        let newSize: CGSize = CGSize(width: collectionViewWidth * CGFloat(nbOfScreen), height: size.height)
        return newSize
    }
}
