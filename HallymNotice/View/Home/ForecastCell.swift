//
//  WeatherCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import SDWebImage

final class ForecastCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "sun.max.fill")
        return iv
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [hourLabel, weatherImageView, tempLabel])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
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
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(forecast: WeatherData) {
        hourLabel.text = "a hh시".makeFormattedDate(date: forecast.date)
        tempLabel.text = "\(Int(forecast.temperature))°"
        
        let urlStr = "https://openweathermap.org/img/wn/\(forecast.icon)@2x.png"
        guard let url = URL(string: urlStr) else { return }
        weatherImageView.sd_setImage(with: url)
    }
}

