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
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitle(" 뒤로", for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let guideView = GuideView()
    private let stepOneView: StepOneView = .init()
    private let stepTwoView: StepTwoView = .init()
    
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
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        
        view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.left.right.equalToSuperview().inset(18)
        }
        
        layoutStepOne()
        layoutStepTwo()
        
        stepTwoView.isHidden = true
    }
    
    func layoutStepOne() {
        view.addSubview(stepOneView)
        stepOneView.snp.makeConstraints { make in
            make.top.equalTo(guideView.snp.bottom).offset(66)
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalTo(view).offset(-50)
        }
    }
    
    func layoutStepTwo() {
        view.addSubview(stepTwoView)
        stepTwoView.snp.makeConstraints { make in
            make.top.equalTo(guideView.snp.bottom).offset(66)
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalTo(view).offset(-50)
        }
    }
    
    func bind() {
        viewModel.guideTitle.zip(viewModel.guideSubTitle)
            .sink { [weak self] (title, subTitle) in
                self?.guideView.bind(title: title, subTitle: subTitle)
            }.store(in: &cancellables)
        
        viewModel.stepOneViewIsHidden
            .assign(to: \.isHidden, on: self.stepOneView)
            .store(in: &cancellables)
        
        viewModel.stepTwoViewIsHidden
            .handleEvents(receiveOutput: { [weak self] isHidden in
                if !isHidden {
                    self?.stepTwoView.playAnimate()
                } else{
                    self?.stepTwoView.pauseAnimate()
                }
            })
            .assign(to: \.isHidden, on: self.stepTwoView)
            .store(in: &cancellables)
        
        stepOneView.bind(viewModel: viewModel)
        stepTwoView.bind(viewModel: viewModel)
        
        backButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.stepChanged(step: 1)
            }.store(in: &cancellables)
        
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



