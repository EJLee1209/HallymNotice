//
//  WelcomViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit
import Combine
import CombineCocoa

final class WelcomeViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    private let guideView = GuideView()
    
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
    
    private lazy var inputTextField: BackgroundTextField = {
        let view = BackgroundTextField()
        view.setBackgroundColor(ThemeColor.secondary)
        view.setPlaceHolder(Constants.inputPlaceHolder)
        view.setCornerRadius(radius: 8)
        view.addAccessoryView()
        view.setTextFieldFont(font: ThemeFont.regular(ofSize: 12))
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 18)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8)
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [inputTextField, adviceLabel, collectionView, nextButton])
        sv.axis = .vertical
        sv.spacing = 18
        sv.alignment = .fill
        return sv
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    let viewModel: WelcomeViewModel
    
    //MARK: - init
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bind()
    }
    
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        
        view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(108)
            make.left.right.equalToSuperview().inset(18)
        }
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(guideView.snp.bottom).offset(73)
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-59)
        }
        
    }
    
    func bind() {
        guideView.bind(title: Constants.welcomeTitle1, subTitle: Constants.welcomeSubTitle1)
        adviceLabel.attributedText = makeAttributedText()
        
        viewModel.setUpDataSource(collectionView: collectionView)
        viewModel.updateHand(with: Constants.defaultKeywords)
        
        inputTextField.doneButtonTap
            .sink { text in
                self.viewModel.appendKeyword(text)
            }.store(in: &cancellables)
        
    }

    func makeAttributedText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(
            string: Constants.welcomeAdvice,
            attributes: [.font: ThemeFont.bold(ofSize: 15)]
        )
        text.addAttributes(
            [.font: ThemeFont.bold(ofSize: 12)]
            , range: NSMakeRange(12, 15))
        return text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



