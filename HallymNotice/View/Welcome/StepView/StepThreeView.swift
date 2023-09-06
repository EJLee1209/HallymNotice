//
//  StepThreeView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import Lottie

final class StepThreeView: UIView {
    
    //MARK: - Properties
    private lazy var lottieAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "animation_check")
        view.loopMode = .playOnce
        return view
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
        addSubview(lottieAnimationView)
        
        lottieAnimationView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(lottieAnimationView.snp.height)
        }
    }
    
    func playAnimate() {
        self.lottieAnimationView.play()
    }
    
}
