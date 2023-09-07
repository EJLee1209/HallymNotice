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
    
    private let weatherView: WeatherView = .init()
    
    let viewModel: HomeViewModel
    
    
    //MARK: - init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bind()
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
//        presentWelcomeVC()
    }
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = bellButton
        
        view.addSubview(weatherView)
        weatherView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(18)
        }
        
    }
    
    func bind() {
        weatherView.bind(viewModel: self.viewModel)
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
