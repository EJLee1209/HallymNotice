//
//  NoticeHeader.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import UIKit
import Combine
import CombineCocoa

final class NoticeHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.text = Constants.homeTitle3
        return label
    }()
    
    private let showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체보기 >", for: .normal)
        button.tintColor = ThemeColor.primary
        button.titleLabel?.font = ThemeFont.bold(ofSize: 12)
        return button
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, showAllButton])
        sv.spacing = 14
        return sv
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // 버튼 탭 Publisher
    private let showAllButtonTappedSubject: PassthroughSubject<Void,Never> = .init()
    var showAllButtonTappedPublisher: AnyPublisher<Void,Never> {
        return showAllButtonTappedSubject.eraseToAnyPublisher()
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        
        showAllButton.tapPublisher
            .sink { [weak self] _ in
                self?.showAllButtonTappedSubject.send(())
            }.store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
    }
}
