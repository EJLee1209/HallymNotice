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
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = ThemeColor.primary
        view.hidesWhenStopped = true
        view.isHidden = true
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [keywordLabel, loadingView])
        sv.axis = .horizontal
        sv.spacing = 12
        return sv
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
        let sv = UIStackView(arrangedSubviews: [hStackView, collectionView])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.searchGuide
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = ThemeColor.primary
        label.font = ThemeFont.demiBold(ofSize: 18)
        return label
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
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel.setupDataSource(collectionView: collectionView)
        collectionView.reachedBottomPublisher()
            .sink { [weak self] _ in
                self?.viewModel.nextPage()
            }.store(in: &cancellables)
        
        viewModel.searchButtonTap
            .compactMap { [weak self] _ in
                self?.viewModel.searchKeyword.value
            }.map { "\"\($0)\" 검색 결과" }
            .sink { [weak self] text in
                self?.keywordLabel.text = text
            }.store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingView.isHidden = !isLoading
                if isLoading {
                    self?.loadingView.startAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchResultTextIsHidden
            .assign(to: \.isHidden, on: self.keywordLabel)
            .store(in: &cancellables)
        
        viewModel.guideLabelText
            .sink { [weak self] text in
                self?.guideLabel.text = text
            }.store(in: &cancellables)
        
        viewModel.guideLabelIsHidden
            .assign(to: \.isHidden, on: self.guideLabel)
            .store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .compactMap { [weak self] indexPath in
                self?.viewModel.selectedNoticeItem(index: indexPath.row)
            }.sink{ [weak self] notice in
                self?.loadWebView(urlString: notice.detailLink)
            }
            .store(in: &cancellables)
    }
    
}
