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
        cv.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.homeHeaderIdentifier)
        cv.register(MenuCell.self, forCellWithReuseIdentifier: Constants.menuCellIdentifier)
        cv.register(NoticeCell.self, forCellWithReuseIdentifier: Constants.noticeCellIdentifier)
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    
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
        presentWelcomeVC()
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
        let noticeItem = (1...10).map { HomeSectionItem.notice(String($0)) }
        viewModel.updateHome(with: menuItem, toSection: .menu)
        viewModel.updateHome(with: noticeItem, toSection: .notice)
    }
    
    private func presentWelcomeVC() {
        let welcomeVM = WelcomeViewModel(keywords: Constants.defaultKeywords)
        let welcomeVC = WelcomeViewController(viewModel: welcomeVM)
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true)
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
            top: 28,
            leading: 15,
            bottom: 0,
            trailing: 15)
        
        // 수평 스크롤 설정
        section.orthogonalScrollingBehavior = .continuous
        
        // header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
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
            heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 28,
            leading: 15,
            bottom: 15,
            trailing: 15)
        
        return section
    }

}
