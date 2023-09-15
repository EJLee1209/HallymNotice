//
//  MenuCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/15.
//

import UIKit

final class MenuCell: UITableViewCell {
    //MARK: - Properties
    
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.addCornerRadius(radius: 8)
        return view
    }()
    
    private let menuImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()
    
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imageBackgroundView, menuLabel])
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        return sv
    }()
    
    private let switchView: UISwitch = .init()
    private let rightArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = ThemeColor.gray
        return iv
    }()
    
    
    static let identifier = "menuCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(15)
        }
        
        imageBackgroundView.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func bind(type: Menu) {
        menuLabel.text = type.rawValue
        menuImageView.image = type.image
        imageBackgroundView.backgroundColor = type.imageBackgroundColor
    }
    
    func setRightContent(isToggleView: Bool = false) {
        if isToggleView {
            hStackView.addArrangedSubview(switchView)
        } else {
            hStackView.addArrangedSubview(rightArrowImageView)
        }
    }
}
