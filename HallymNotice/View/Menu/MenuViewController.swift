//
//  MenuViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit


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
        if type == .notification {
            cell.setRightContent(isToggleView: true)
        } else {
            cell.setRightContent()
        }
        
        
        return cell
    }
}
