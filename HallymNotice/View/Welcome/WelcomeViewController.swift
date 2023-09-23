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

protocol WelcomeVCDelegate: AnyObject {
    func endOfRegister(user: User?)
}

final class WelcomeViewController: UIViewController, BaseViewController {
    //MARK: - Properties
    
    private let guideView = GuideView()
    private let stepOneView: StepOneView = .init()
    private let stepThreeView: StepTwoView = .init()
    
    private var cancellables: Set<AnyCancellable> = .init()
    var delegate: WelcomeVCDelegate?
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.left.right.equalToSuperview().inset(18)
        }
        
        layoutStepOne()
        layoutStepThree()
    }
    
    func layoutStepOne() {
        view.addSubview(stepOneView)
        stepOneView.snp.makeConstraints { make in
            make.top.equalTo(guideView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalTo(view).offset(-50)
        }
    }
    
    func layoutStepThree() {
        view.addSubview(stepThreeView)
        stepThreeView.snp.makeConstraints { make in
            make.top.equalTo(guideView.snp.bottom).offset(66)
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalTo(view).offset(-50)
        }
    }
    
    func bind() {
        viewModel.guideTitle.zip(viewModel.guideSubTitle)
            .sink { [weak self] (title, subTitle) in
                UIView.animate(withDuration: 0.25) {
                    self?.guideView.layer.opacity = 0
                    self?.guideView.layoutIfNeeded()
                } completion: { _ in
                    
                    self?.guideView.bind(title: title, subTitle: subTitle)
                    UIView.animate(withDuration: 0.25) {
                        self?.guideView.layer.opacity = 1
                        self?.guideView.layoutIfNeeded()
                    }
                }
            }.store(in: &cancellables)
        
        viewModel.stepOneViewIsHidden
            .assign(to: \.isHidden, on: self.stepOneView, animation: .fade(duration: 0.5))
            .store(in: &cancellables)
        
        viewModel.stepTwoViewIsHidden
            .handleEvents(receiveOutput: { [weak self] isHidden in
                if !isHidden {
                    self?.stepThreeView.playAnimate()
                }
            })
            .assign(to: \.isHidden, on: self.stepThreeView, animation: .fade(duration: 0.5))
            .store(in: &cancellables)
        
        viewModel.endOfRegister
            .sink { [weak self] user in
                self?.delegate?.endOfRegister(user: user)
                self?.dismiss(animated: true)
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
    
    @objc func endOfRegister() {
        
    }
}
