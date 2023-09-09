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
        cv.register(MenuHeaderView.self, forSupplementaryViewOfKind: Constants.menuHeaderViewKind, withReuseIdentifier: Constants.menuHeaderIdentifier)
        cv.register(NoticeHeaderView.self, forSupplementaryViewOfKind: Constants.noticeHeaderViewKind, withReuseIdentifier: Constants.noticeHeaderIdentifier)
        cv.register(MenuCell.self, forCellWithReuseIdentifier: Constants.menuCellIdentifier)
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
        navigationItem.rightBarButtonItem = bellButton
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func bind() {
        viewModel.setupHomeDataSource(collectionView: self.collectionView)
        
        let menuItem = (1...10).map { HomeSectionItem.menu(String($0)) }
        viewModel.updateHome(with: menuItem, toSection: .menu)
        viewModel.showAllNoticeButtonTap
            .sink { [weak self] _ in
                self?.showAllNotice()
            }.store(in: &cancellables)

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
            case .menu:
                return self.makeMenuSection()
            case .notice:
                return self.makeNoticeSection()
            }
        }

        return layout
    }
    
    private func makeMenuSection() -> NSCollectionLayoutSection? {
        
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 10
        )
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .estimated(146))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 19,
            leading: 15,
            bottom: 28,
            trailing: 15)
        
        // 수평 스크롤 설정
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.menuHeaderViewKind,
            alignment: .top)

        section.boundarySupplementaryItems = [header]
        return section
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
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.noticeHeaderViewKind,
            alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }

}
