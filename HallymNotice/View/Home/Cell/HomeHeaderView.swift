//
//  HomeHeaderView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import UIKit

final class HomeHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    private let weatherView: WeatherView = .init()
    
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
        addSubview(weatherView)
        weatherView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func bind(viewModel: HomeViewModel) {
        weatherView.bind(viewModel: viewModel)
    }
    
    
}
