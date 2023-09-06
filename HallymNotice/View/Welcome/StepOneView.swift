//
//  StepOneView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import Combine
import CombineCocoa

final class StepOneView: UIView {
    
    //MARK: - Properties
    
    private lazy var inputTextField: BackgroundTextField = {
        let view = BackgroundTextField()
        view.setBackgroundColor(ThemeColor.secondary)
        view.setPlaceHolder(Constants.inputPlaceHolder)
        view.setCornerRadius(radius: 8)
        view.addAccessoryView()
        view.setTextFieldFont(font: ThemeFont.regular(ofSize: 12))
        return view
    }()
    
    private let adviceLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.gray
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(KeywordCell.self, forCellWithReuseIdentifier: Constants.keywordCellIdentifier)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 18)
        button.backgroundColor = ThemeColor.gray
        button.addCornerRadius(radius: 8)
        button.isEnabled = false
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [inputTextField, adviceLabel, collectionView])
        sv.axis = .vertical
        sv.spacing = 18
        sv.alignment = .fill
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
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-30)
        }
    }
    
    func bind(viewModel: WelcomeViewModel) {
        
        adviceLabel.attributedText = makeAttributedText()
        
        viewModel.setUpDataSource(collectionView: collectionView)
        viewModel.updateHand(with: Constants.defaultKeywords)
        
        inputTextField.doneButtonTap
            .sink { text in
                let keyword = Keyword(text: text, isSelected: true)
                viewModel.appendKeyword(keyword)
            }.store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .sink { indexPath in
                viewModel.selectKeyword(indexPath.row)
            }.store(in: &cancellables)
        
        viewModel.validation
            .sink { [weak self] validation in
                if validation {
                    self?.nextButton.isEnabled = true
                    self?.nextButton.backgroundColor = ThemeColor.primary
                } else {
                    self?.nextButton.isEnabled = false
                    self?.nextButton.backgroundColor = ThemeColor.gray
                }
            }.store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { _ in
                // 2단계 설정으로 이동
                viewModel.stepChanged(step: 2)
            }.store(in: &cancellables)
        
    }
    
    private func makeAttributedText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(
            string: Constants.welcomeAdvice,
            attributes: [.font: ThemeFont.bold(ofSize: 15)]
        )
        text.addAttributes(
            [.font: ThemeFont.bold(ofSize: 12)]
            , range: NSMakeRange(12, 15))
        return text
    }
}

