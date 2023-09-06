//
//  KeywordCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit

final class KeywordCell: UICollectionViewCell {
    
    //MARK: - Properties
    let bgView: UIView = {
        let view = UIView()
        view.addCornerRadius(radius: 8)
        view.backgroundColor = ThemeColor.secondary
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.gray
        label.font = ThemeFont.bold(ofSize: 13)
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
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(17)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    func bind(keyword: Keyword) {
        label.text = keyword.text
        if keyword.isSelected {
            bgView.backgroundColor = ThemeColor.primary
            label.textColor = .white
        } else {
            bgView.backgroundColor = ThemeColor.secondary
            label.textColor = ThemeColor.gray
        }
    }
}
