//
//  TabCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/11.
//

import UIKit
import Combine
import CombineCocoa

final class TabItemView: UIView {
    
    let tabButton: AutoPaddingButton = {
        let button = AutoPaddingButton(type: .system)
        button.padding = .init(width: 12, height: 8)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    var tabSelected: AnyPublisher<Int, Never> {
        return tabButton.tapPublisher
            .compactMap { self.itemIndex }
            .eraseToAnyPublisher()
    }
    
    var tabItem: NoticeCategory? {
        didSet {
            bind(tabItem: tabItem)
        }
    }
    
    var itemIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(tabButton)
        tabButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind(tabItem: NoticeCategory?) {
        tabButton.setTitle(tabItem?.rawValue, for: .normal)
    }
    
    
    
}
