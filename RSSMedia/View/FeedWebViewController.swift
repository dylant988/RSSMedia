//
//  FeedWebViewController.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import UIKit
import WebKit

class FeedWebViewController: BaseViewController {

    var feedWebView: WKWebView!
    var viewModel : FeedWebViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    // MARK: Initialize all instances
    func initialize() {
        initializeLocalization()
        initializeWebView()
    }
    
    func initializeLocalization() {
        title = NSLocalizedString(FeedWebViewTitle, comment: "")
    }
    
    // MARK: Create web view
    func initializeWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let navigationBarMaxY: CGFloat = self.navigationController!.navigationBar.frame.maxY
        let frame = CGRect(x: 0, y: navigationBarMaxY, width: view.frame.width, height: view.frame.height - navigationBarMaxY)
        feedWebView = WKWebView(frame: frame, configuration: webConfiguration)
        view.addSubview(feedWebView)
        var url = viewModel.getFeedURL()
        url =  url.replacingOccurrences(of: " ", with:"")
        url =  url.replacingOccurrences(of: "\n", with:"")
        feedWebView.load(URLRequest(url: URL(string: url)!))
    }

}
