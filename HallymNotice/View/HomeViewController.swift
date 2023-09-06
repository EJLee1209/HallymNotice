//
//  HomeViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit

class HomeViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
            
        presentWelcomeVC()
    }
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
    }
    
    func bind() {
        
    }
    
    private func presentWelcomeVC() {
        let welcomeVM = WelcomeViewModel(keywords: Constants.defaultKeywords)
        let welcomeVC = WelcomeViewController(viewModel: welcomeVM)
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true)
    }
    
}
