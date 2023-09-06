//
//  StepTwoView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import Combine
import CombineCocoa
import Lottie

final class StepTwoView: UIView {
    
    //MARK: - Properties
    private lazy var lottieAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "animation_notification")
        view.loopMode = .loop
        return view
    }()
    
    private let positivieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.welcomeNoticePositiveButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 18)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8)
        return button
    }()
    
    private let negativeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.welcomeNoticeNegativeButtonText, for: .normal)
        button.setTitleColor(ThemeColor.gray, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 18)
        button.backgroundColor = ThemeColor.secondary
        button.addCornerRadius(radius: 8)
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            lottieAnimationView,
            UIView(),
            positivieButton,
            negativeButton
        ])
        sv.spacing = 19
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    private func layout() {
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lottieAnimationView.snp.makeConstraints { make in
            make.height.equalTo(lottieAnimationView.snp.width)
        }
        
        
    }
    
    func playAnimate() {
        self.lottieAnimationView.play()
    }
    
    func pauseAnimate() {
        self.lottieAnimationView.pause()
    }
    
    func bind(viewModel: WelcomeViewModel) {
        
        
        
    }
    
}
