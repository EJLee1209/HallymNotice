//
//  HomeHeaderView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import UIKit

final class MenuHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    private let weatherView: WeatherView = .init()
    
    private let menuHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.text = Constants.homeTitle2
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [weatherView, menuHeaderLabel])
        sv.axis = .vertical
        sv.spacing = 28
        return sv
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
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func bind(viewModel: HomeViewModel) {
        weatherView.bind(viewModel: viewModel)
    }
    
    
}
