//
//  UIImageViewExtension.swift
//  YinKe
//
//  Created by IT A on 2018/7/20.
//  Copyright © 2018 Manta. All rights reserved.
//

import Foundation
import Kingfisher

enum QNImageResolution {
    case normal
    case avatar
    case news
    
    var suffix: String {
        switch self {
        case .avatar:
            return "?imageView2/2/w/100"
        case .news:
            return "?imageView2/2/w/\(222)"
        default:
            return ""
        }
    }
}

enum YKImagePlaceHolder {
    case normal
    
    case avatar
    
    var image: UIImage? {
        switch self {
        case .avatar:
            return UIImage(named: "avatarPlacehold")
        default:
            return UIImage(named: "placeholderImage")
        }
    }
}



extension UIImageView {
    
    func ykSetImage(with urlString: String?, placeholder: YKImagePlaceHolder = .normal) {
        let url = URL(string: urlString ?? "")
        self.kf.setImage(with: url, placeholder: placeholder.image, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func ykSetImage(with urlString: String?, placeholder: UIImage) {
        let url = URL(string: urlString ?? "")
        self.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
    }
}

extension UIButton {
    func ykSetImage(with urlString: String?, placeholder: YKImagePlaceHolder = .normal) {
        let url = URL(string: urlString ?? "")
        self.kf.setImage(with: url, for: .normal, placeholder: placeholder.image, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func ykSetBackgroundImage(with urlString: String?, placeholder: YKImagePlaceHolder = .normal) {
        let url = URL(string: urlString ?? "")
        self.kf.setBackgroundImage(with: url, for: .normal, placeholder: placeholder.image, options: nil, progressBlock: nil, completionHandler: nil)
    }
}

