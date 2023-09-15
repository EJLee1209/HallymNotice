//
//  TabView.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/11.
//

import UIKit
import CombineCocoa
import Combine

final class TabView: UIView {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.alwaysBounceVertical = false
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    
    private let tabIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private var items: [NoticeCategory] = []
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var tabSelectedSubject: PassthroughSubject<Int, Never> = .init()
    var selectedTabPublisher: AnyPublisher<NoticeCategory, Never> {
        return tabSelectedSubject.map { self.items[$0] }.eraseToAnyPublisher()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(items: [NoticeCategory]) {
        var tabViews = [TabItemView]()
        
        for (idx, item) in items.enumerated() {
            let tab = TabItemView()
            tab.tabItem = item
            tab.itemIndex = idx
            hStackView.addArrangedSubview(tab)
            tabViews.append(tab)
        }
        self.items = items
        
        // 모든 탭의 selected publisher를 merge해서 하나의 publisher로 변환
        Publishers.MergeMany(tabViews.map { $0.tabSelected })
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false) // 2초에 한번씩만 값을 발행하도록
            .sink { [weak self] idx in
                self?.tabSelectedSubject.send(idx)
            }.store(in: &cancellables)
        
        guard let firstItemView = hStackView.arrangedSubviews.first else { return }
        
        scrollView.addSubview(tabIndicatorView)
        tabIndicatorView.snp.makeConstraints { make in
            make.centerX.equalTo(firstItemView)
            make.top.equalTo(firstItemView.snp.bottom)
            make.width.equalTo(firstItemView)
            make.height.equalTo(3)
        }
    }
    
    func bind() {
        
        tabSelectedSubject
            .sink { [weak self] idx in
                self?.moveIndicatorToSelectedTab(for: idx)
            }.store(in: &cancellables)
    }
    
    private func moveIndicatorToSelectedTab(for index: Int) {
        
        let tabItemView = self.hStackView.arrangedSubviews[index]
        
        self.tabIndicatorView.snp.remakeConstraints { make in
            make.centerX.equalTo(tabItemView)
            make.top.equalTo(tabItemView.snp.bottom)
            make.width.equalTo(tabItemView)
            make.height.equalTo(3)
        }
        
        var x = tabItemView.frame.midX - frame.width / 2
        x = x < 0 ? 0 : x
        x = x + frame.width < scrollView.contentSize.width ? x : scrollView.contentSize.width - frame.width
        let point = CGPoint(x: x, y: 0)
        
        scrollView.setContentOffset(point, animated: true)
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
