//
//  AutoPaddingButton.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/08/26.
//

import UIKit

class AutoPaddingButton: UIButton {
    var padding: CGSize = .init(width: 0, height: 0) {
        didSet {
            invalidateIntrinsicContentSize() // 크기 다시 계산
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let baseSize = super.intrinsicContentSize
            return CGSize(width: baseSize.width + padding.width, height: baseSize.height + padding.height)
        }
    }
}
