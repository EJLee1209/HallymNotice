//
//  NoticeHeader.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import UIKit

final class NoticeHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    private let weatherView: WeatherView = .init()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 18)
        label.text = Constants.homeTitle3
        return label
    }()
    
    private lazy var showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 보기 >", for: .normal)
        button.tintColor = ThemeColor.primary
        button.titleLabel?.font = ThemeFont.bold(ofSize: 14)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, showAllButton])
        sv.axis = .horizontal
        sv.spacing = 12
        return sv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [weatherView, hStackView])
        sv.axis = .vertical
        sv.spacing = 28
        return sv
    }()
    
    
    
    var buttonTapped: () -> Void = {}
    
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
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(viewModel: HomeViewModel) {
        weatherView.bind(viewModel: viewModel)
    }
    
    
    
    //MARK: - Actions
    @objc private func handleButtonTapped() {
        buttonTapped()
    }
}
