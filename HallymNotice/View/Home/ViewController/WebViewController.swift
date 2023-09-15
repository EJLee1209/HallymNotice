//
//  WebViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/10.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        view.navigationDelegate = self
        return view
    }()
    private let loadingView: LoadingView = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
    }

    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    func bind(urlString: String) {
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: encodedStr) else { return }
        let request = URLRequest(url: url)
        
        self.webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // 페이지 로딩 시작 시 액티비티 인디케이터 표시 시작
        self.loadingView.showLoadingViewAndStartAnimation()
   }

   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       // 페이지 로딩 완료 시 액티비티 인디케이터 표시 종료
       self.loadingView.hideLoadingViewAndStopAnimation()
   }
   
   func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       // 페이지 로딩 실패 시 액티비티 인디케이터 표시 종료 (옵셔널)
       self.loadingView.hideLoadingViewAndStopAnimation()
   }
}
