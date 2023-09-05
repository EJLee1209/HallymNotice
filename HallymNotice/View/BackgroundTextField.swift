//
//  PaddingTextField.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit

final class BackgroundTextField: UIView {
    
    private var backgroundView: UIView = UIView()
    private var textField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        backgroundView.backgroundColor = color
    }
    
    func setPlaceHolder(_ text: String) {
        textField.placeholder = text
    }
    
    func setCornerRadius(radius: CGFloat) {
        backgroundView.addCornerRadius(radius: radius)
    }
    
    func addAccessoryView() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped))
        toolBar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            doneButton
        ]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped() {
        textField.endEditing(true)
    }
}

