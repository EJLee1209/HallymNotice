//
//  HomeViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class HomeViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    private lazy var bellButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .done,
            target: self,
            action: #selector(bellButtonTapped)
        )
        button.tintColor = .black
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.makeFlowLayout())
        cv.register(NoticeHeaderView.self, forSupplementaryViewOfKind: Constants.noticeHeaderViewKind, withReuseIdentifier: Constants.noticeHeaderIdentifier)
        cv.register(NoticeCell.self, forCellWithReuseIdentifier: Constants.noticeCellIdentifier)
        cv.delaysContentTouches = false
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    let viewModel: HomeViewModel
    
    
    //MARK: - init
    
    init(viewModel: HomeViewModel) {
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
//        presentWelcomeVC()
    }
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [bellButton]
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func bind() {
        viewModel.setupHomeDataSource(collectionView: self.collectionView)
        
        viewModel.updateHome(with: [], toSection: .notice)
        
        viewModel.showAllNoticeButtonTap
            .sink { [weak self] _ in
                self?.showAllNotice()
            }.store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .compactMap { [weak self] indexPath in
                self?.viewModel.selectedSectionItem(section: indexPath.section, index: indexPath.row)
            }.sink{ [weak self] notice in
                switch notice {
                case .notice(let notice):
                    self?.loadWebView(urlString: notice.detailLink)
                }
            }
            .store(in: &cancellables)

    }
    
    private func presentWelcomeVC() {
        let welcomeVM = WelcomeViewModel(keywords: Constants.defaultKeywords)
        let welcomeVC = WelcomeViewController(viewModel: welcomeVM)
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true)
    }
    
    private func showAllNotice() {
        let noticeVM = viewModel.makeNoticeViewModel()
        let noticeVC = NoticeViewController(viewModel: noticeVM)
        navigationController?.pushViewController(noticeVC, animated: true)
    }
    
    
    //MARK: - Actions
    
    @objc private func bellButtonTapped() {
        print("DEBUG: bell button tapped")
    }
    
}


//MARK: - CompositionalLayout
extension HomeViewController {

    private func makeFlowLayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { section, ev -> NSCollectionLayoutSection? in
            switch HomeSection.allCases[section] {
            case .notice:
                return self.makeNoticeSection()
            }
        }

        return layout
    }
    
    private func makeNoticeSection() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0
        )
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 19,
            leading: 15,
            bottom: 15,
            trailing: 15)
        
        // header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.noticeHeaderViewKind,
            alignment: .top)

        section.boundarySupplementaryItems = [header]
        
        return section
    }

}
