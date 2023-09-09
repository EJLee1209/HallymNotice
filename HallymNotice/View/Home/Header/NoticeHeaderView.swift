//
//  NoticeHeader.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import UIKit

final class NoticeHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.text = Constants.homeTitle3
        return label
    }()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
    }
}
