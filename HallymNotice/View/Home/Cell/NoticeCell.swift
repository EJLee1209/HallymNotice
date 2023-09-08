//
//  NoticeCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import UIKit

final class NoticeCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = ThemeFont.bold(ofSize: 20)
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        
        backgroundColor = .systemBlue
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func bind(text: String) {
        label.text = text
    }
}
