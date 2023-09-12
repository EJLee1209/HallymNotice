//
//  MenuCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import UIKit

final class MenuCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let menuImageView: UIImageView = {
        let view = UIImageView()
        return view
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
        
        backgroundColor = .white
        
        contentView.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
    }
    
    func bind(imgUrl: String) {
        guard let url = URL(string: imgUrl) else { return }
        menuImageView.sd_setImage(with: url)
    }
}


