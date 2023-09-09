//
//  NoticeCell.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import UIKit

final class NoticeCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 12)
        view.addShadow(
            offset: CGSize(width: 1, height: 1),
            color: .gray,
            shadowRadius: 2,
            opacity: 0.7,
            cornerRadius: 12
        )
        return view
    }()
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let writerLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 13)
        label.textColor = ThemeColor.gray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 13)
        label.textColor = ThemeColor.gray
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [writerLabel, dateLabel])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titlelabel, hStackView])
        sv.axis = .vertical
        sv.spacing = 5
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
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentBackgroundView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func bind(date: String, notice: Notice) {
        titlelabel.text = notice.title
        writerLabel.text = notice.writer
        
        if date == notice.publishDate {
            let text = NSMutableAttributedString(
                string: "NEW  \(notice.publishDate)"
            )
            text.addAttributes(
                [
                    .foregroundColor: UIColor.systemRed,
                    .font: ThemeFont.demiBold(ofSize: 9)
                ],
                range: NSMakeRange(0, 3))
            dateLabel.attributedText = text
        } else {
            dateLabel.text = notice.publishDate
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bounceAnimate(isTouched: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bounceAnimate(isTouched: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        bounceAnimate(isTouched: false)
    }
    
    private func bounceAnimate(isTouched: Bool) {
        
        if isTouched {
            NoticeCell.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: [.allowUserInteraction],
                animations: {
                    self.transform = .init(scaleX: 0.96, y: 0.96)
                    self.layoutIfNeeded()
                }, completion: nil)
        } else {
            NoticeCell.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [.allowUserInteraction],
                animations: {
                    self.transform = .identity // 원상태로 복구
                }, completion: nil)
        }
        
    }
}
