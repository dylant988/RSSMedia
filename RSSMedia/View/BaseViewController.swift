//
//  BaseViewController.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/23/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import UIKit

// MARK: Provide configured base viewController
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNativationBar()
        
        
        
    }
    
    // MARK: Change back button color and set transparent navigation bar.
    func initializeNativationBar() {
        let backButton = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        backButton.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton;
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }

}
