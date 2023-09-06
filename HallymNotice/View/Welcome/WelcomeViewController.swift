//
//  WelcomViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit
import Combine
import CombineCocoa
import Lottie

final class WelcomeViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    private let guideView = GuideView()
    private let stepOneView: StepOneView = .init()
    
    private lazy var lottieAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "animation_notification")
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    let viewModel: WelcomeViewModel
    
    //MARK: - init
    init(viewModel: WelcomeViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(108)
            make.left.right.equalToSuperview().inset(18)
        }
        
        layoutStepOne()
        
    }
    
    func layoutStepOne() {
        view.addSubview(stepOneView)
        stepOneView.snp.makeConstraints { make in
            make.top.equalTo(guideView.snp.bottom).offset(66)
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
    
    func bind() {
        viewModel.guideTitle.zip(viewModel.guideSubTitle)
            .sink { [weak self] (title, subTitle) in
                self?.guideView.bind(title: title, subTitle: subTitle)
            }.store(in: &cancellables)
        
        stepOneView.bind(viewModel: viewModel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    //MARK: - Actions
    
    @objc func keyboardUp(notification:NSNotification) {
        UIView.animate(
            withDuration: 0.3
            , animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -50)
            }
        )
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
}



