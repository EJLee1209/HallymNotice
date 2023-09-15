//
//  EditKeywordViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/15.
//

import UIKit
import Combine
import CombineCocoa

class EditKeywordViewController: UIViewController, BaseViewController {
    //MARK: - Properties
    private lazy var inputTextField: BackgroundTextField = {
        let view = BackgroundTextField()
        view.setBackgroundColor(ThemeColor.secondary)
        view.setPlaceHolder(Constants.inputPlaceHolder2)
        view.setCornerRadius(radius: 8)
        view.addAccessoryView()
        view.setTextFieldFont(font: ThemeFont.regular(ofSize: 12))
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "keywordCell")
        tv.rowHeight = 50
        return tv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [inputTextField, tableView])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var keywords: [String] = Constants.defaultKeywords.map { $0.text }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bind()
    }
    
    //MARK: - Helpers
    func layout() {
        navigationItem.title = "알림 키워드 편집"
        view.backgroundColor = .white
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func bind() {
        inputTextField.doneButtonTap
            .sink { [weak self] keyword in
                self?.addKeywords(keyword: keyword)
            }.store(in: &cancellables)
    }
    
    func addKeywords(keyword: String) {
        if !keywords.contains(keyword) {
            keywords.insert(keyword, at: 0)
            tableView.reloadData()
        }
    }
    func removeKeywords(at indexPath: IndexPath, to tableView: UITableView) {
        keywords.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - UITableViewDataSource
extension EditKeywordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)
        cell.textLabel?.text = keywords[indexPath.row]
        return cell
    }
    
    
}


//MARK: - UITableViewDelegate
extension EditKeywordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeKeywords(at: indexPath, to: tableView)
        }
    }
    
}
