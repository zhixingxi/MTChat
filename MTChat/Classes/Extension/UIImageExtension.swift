//
//  UIImageExtension.swift
//  MTChat
//
//  Created by IT A on 2018/11/28.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func creatImage(imageName: String, isSender: Bool) -> UIImage? {
        guard let img = UIImage(named: imageName) else {return nil}
        let stretchWidth: CGFloat = img.size.width / 5.0
        let stretchHeight: CGFloat = img.size.height / 5.0
        var resizeImage: UIImage?
        if isSender {
            resizeImage = img.resizableImage(withCapInsets: UIEdgeInsets(top: stretchHeight, left: stretchWidth, bottom: img.size.height - stretchHeight, right: stretchWidth), resizingMode: .stretch)
        } else {
            resizeImage = img.resizableImage(withCapInsets: UIEdgeInsets(top: img.size.height - stretchHeight, left: stretchWidth, bottom: stretchHeight, right: stretchWidth), resizingMode: .stretch)
        }
        return resizeImage
    }
}

