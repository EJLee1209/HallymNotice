//
//  WelcomViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit

final class WelcomeViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
    }
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        
    }
    
    func bind() {
        
    }
}
