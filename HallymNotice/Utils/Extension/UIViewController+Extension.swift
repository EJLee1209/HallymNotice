//
//  UIViewController+Extension.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/10.
//

import UIKit

extension UIViewController {
    func loadWebView(urlString: String) {
        let webVC = WebViewController()
        webVC.bind(urlString: urlString)
        guard let nav = self.navigationController else {
            self.presentingViewController?.navigationController?.pushViewController(webVC, animated: true)
            return
        }
        nav.pushViewController(webVC, animated: true)
    }
}
