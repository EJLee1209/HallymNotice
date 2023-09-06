//
//  GuideLabel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit
import SnapKit

final class GuideView: UIView {
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(title: String, subTitle: String) {
        let text = NSMutableAttributedString(
            string: title,
            attributes: [.font: ThemeFont.bold(ofSize: 32)]
        )
        let attrString = NSAttributedString(
            string: subTitle,
            attributes: [.font: ThemeFont.bold(ofSize: 16)]
        )
        text.append(attrString)
        guideLabel.attributedText = text
    }
    
}
