//
//  WeatherView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import Combine
import CombineCocoa

final class WeatherView: UIView {
    
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.text = Constants.homeTitle1
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        iv.addCornerRadius(radius: 12)
        iv.clipsToBounds = true
        iv.image = UIImage(named: "bg_cloud")
        return iv
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.addShadow(
            offset: CGSize(width: 3, height: 3),
            color: .black,
            shadowRadius: 1.5,
            opacity: 0.7,
            cornerRadius: 12
        )
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.addCornerRadius(radius: 12)
        view.layer.opacity = 0.8
        return view
    }()
    
    private let localLabel: UILabel = {
        let label = UILabel()
        label.text = "춘천시 퇴계동"
        label.font = ThemeFont.bold(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "30°"
        label.font = ThemeFont.bold(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(WeatherCell.self, forCellWithReuseIdentifier: Constants.weatherCellIdentifier)
        return cv
    }()
    
    private lazy var contentVStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [localLabel, tempLabel, collectionView])
        sv.axis = .vertical
        sv.spacing = 13
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var rootVStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, backgroundView])
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
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
        addSubview(rootVStack)
        rootVStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(backgroundView.snp.width).dividedBy(1.7)
        }
        
        backgroundView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }
        
        weatherImageView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        weatherImageView.addSubview(contentVStackView)
        contentVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
    }
    
    
    func bind(viewModel: HomeViewModel) {
        viewModel.address
            .assign(to: \.text!, on: self.localLabel)
            .store(in: &cancellables)
    }
    
}
