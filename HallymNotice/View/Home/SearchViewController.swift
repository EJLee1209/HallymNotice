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
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [keywordLabel, collectionView])
        sv.axis = .vertical
        sv.spacing = 8
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
            make.left.right.bottom.equalToSuperview().inset(18)
        }
    }
    
    func bind() {
        viewModel.searchKeyword
            .map { "\"\($0)\" 검색 결과" }
            .sink { text in
                self.keywordLabel.text = text
            }.store(in: &cancellables)
    }
}
