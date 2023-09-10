//
//  SearchViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/10.
//

import UIKit
import Combine
import CombineCocoa

class SearchViewController: UIViewController, BaseViewController {
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 18)
        label.text = "\"진로\" 검색결과"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        layout.sectionInset = .init(top: 12, left: 0, bottom: 100, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NoticeCell.self, forCellWithReuseIdentifier: Constants.noticeCellIdentifier)
        cv.alwaysBounceVertical = true
        cv.delaysContentTouches = false
        return cv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [keywordLabel, collectionView])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    var cancellables: Set<AnyCancellable> = .init()
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }

    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.left.right.bottom.equalToSuperview()
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func bind() {
        viewModel.searchKeyword
            .map { "\"\($0)\" 검색 결과" }
            .sink { text in
                print(text)
                self.keywordLabel.text = text
            }.store(in: &cancellables)
        
        viewModel.setupDataSource(collectionView: collectionView)
        
        collectionView.reachedBottomPublisher()
            .sink { [weak self] _ in
                self?.viewModel.nextPage()
            }.store(in: &cancellables)
    }
}
