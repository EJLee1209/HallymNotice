//
//  AllNoticeViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import UIKit
import Combine
import CombineCocoa

class NoticeViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        layout.sectionInset = .init(top: 12, left: 0, bottom: 12, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NoticeCell.self, forCellWithReuseIdentifier: Constants.noticeCellIdentifier)
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    var cancellables: Set<AnyCancellable> = .init()
    
    let viewModel: NoticeViewModel
    
    //MARK: - init
    init(viewModel: NoticeViewModel) {
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
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind() {
        // navigation title
        viewModel.title
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
        
        // Diffable DataSource 세팅
        viewModel.setupDataSource(collectionView: self.collectionView)
        
        // CollectionView의 스크롤이 하단에 도달했을 때 다음 페이지 공지사항을 요청
        collectionView.reachedBottomPublisher()
            .sink { [weak self] _ in
                self?.viewModel.nextPage()
            }.store(in: &cancellables)
    }
}
