//
//  MenuViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import Combine
import CombineCocoa

class MenuViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        tv.rowHeight = 60
        tv.alwaysBounceVertical = true
        tv.dataSource = self
        return tv
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: MenuViewModel
    
    //MARK: - init
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        layout()
        bind()
        
    }
    
    //MARK: - Helpers
    
    private func setupNav() {
        navigationItem.title = "메뉴"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func layout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        tableView.didSelectRowPublisher
            .handleEvents(receiveOutput: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map { Menu.allCases[$0.row] }
            .sink { [weak self] menu in
                self?.selectMenu(menu)
            }.store(in: &cancellables)
    }
    
    private func selectMenu(_ menu: Menu) {
        switch menu {
        case .notification:
            self.openAppSettings()
        case .keywords:
            self.navigateToEditKeywordVC()
        case .talkToDeveloper:
            print("개발자에게 한마디")
        case .privacyPolicy:
            self.loadWebView(urlString: "https://sites.google.com/view/hallym-notice-privacy/홈")
        }
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func navigateToEditKeywordVC() {
        let vc = EditKeywordViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        let type = Menu.allCases[indexPath.row]
        cell.bind(type: type)
        return cell
    }
}
