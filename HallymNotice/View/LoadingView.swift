//
//  LoadingView.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import UIKit

final class LoadingView: UIView {
    
    //MARK: - Properties
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let oneDotView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.primary
        view.clipsToBounds = true
        return view
    }()
    
    private let twoDotView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.primary
        view.clipsToBounds = true
        return view
    }()
    
    private let threeDotView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.primary
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [oneDotView,twoDotView,threeDotView])
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        isHidden = true
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        [oneDotView, twoDotView, threeDotView].forEach { view in
            view.snp.makeConstraints { make in
                make.size.equalTo(12)
            }
            
            view.addCornerRadius(radius: 6)
        }
    }
    
    func setLoadingViewCornerRadius() {
        backgroundView.addCornerRadius(radius: backgroundView.frame.height/2)
    }
    
    func showLoadingViewAndStartAnimation() {
        isHidden = false
        
        makeOpacityKeyFrame(targetView: self.oneDotView)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.35) { [weak self] in
            self?.makeOpacityKeyFrame(targetView: self?.twoDotView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) { [weak self] in
            self?.makeOpacityKeyFrame(targetView: self?.threeDotView)
        }
    }
    
    func hideLoadingViewAndStopAnimation() {
        self.isHidden = true
        [oneDotView, twoDotView, threeDotView].forEach { $0.layer.removeAllAnimations() }
    }
    
    private func makeOpacityKeyFrame(targetView: UIView?) {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: .repeat,
            animations: {
                UIView.addKeyframe(
                  withRelativeStartTime: 0,
                  relativeDuration: 1 / 2,
                  animations: { targetView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) }
                )
                
                UIView.addKeyframe(
                  withRelativeStartTime: 1 / 2,
                  relativeDuration: 1 / 2,
                  animations: { targetView?.transform = .identity }
                )
                
                UIView.addKeyframe(
                  withRelativeStartTime: 0,
                  relativeDuration: 1 / 2,
                  animations: { targetView?.alpha = 0 }
                )
                
                UIView.addKeyframe(
                  withRelativeStartTime: 1 / 2,
                  relativeDuration: 1 / 2,
                  animations: { targetView?.alpha = 1 }
                )
              },
              completion: nil
        )
        
    }
}
