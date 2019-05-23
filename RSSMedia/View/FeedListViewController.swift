//
//  FeedListViewController.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class FeedListViewController: BaseViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var myFeedsBarBtnItm: UIBarButtonItem!
    var viewModel: FeedListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        feedTableView.reloadData() // Avoid table view cell from being selected
    }
    
    // MARK: Initialize all instances
    func initialize() {
        initializeLocalization()
        viewModel = FeedListViewModel()
        initializeTableView()
        viewModel.getRSSFeed { [weak self] in
            self?.feedTableView.reloadData()
        }
    }
    
    func initializeLocalization() {
        title = NSLocalizedString(FeedListViewTitle, comment: "")
        myFeedsBarBtnItm.title = NSLocalizedString("My Feeds", comment: "")
    }
    
    // MARK: Initialize table view, set up delegate
    func initializeTableView() {
        feedTableView.estimatedRowHeight = CGFloat(rowHeight)
        feedTableView.rowHeight = UITableView.automaticDimension // Set table view adaptive row height
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.tableFooterView = UIView() // Remove the separators after the last feed
    }
    
}

extension FeedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowNum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedTableViewCell else { return UITableViewCell() }
        let feed = viewModel.getFeed(at: indexPath.row)
        let date = feed.formatDate(dateString: feed.pubDate)
        cell.titleLabel.text = feed.title
        cell.descLabel.text = feed.desc
        cell.dateLabel.text = date
        cell.saveBtn.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)
        cell.saveBtn.tag = indexPath.row
        if feed.isSaved {
            cell.saveBtn.isEnabled = false // If data is not in Core Data, disable the SAVE button
        }
        cell.saveBtn.addTarget(self, action: #selector(saveCurrentFeed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "webViewSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webViewController = segue.destination as? FeedWebViewController else { return }
        webViewController.viewModel = FeedWebViewModel(feedURL: viewModel.getFeed(at: feedTableView.indexPathForSelectedRow!.row).link)
    }
    
    @objc func saveCurrentFeed(_ sender: UIButton) {
        viewModel.saveSelectedFeed(index: sender.tag) { isSaved in
            DispatchQueue.main.async {
                if isSaved {
                    sender.isEnabled = false // If saved operation done, disable the SAVE button
                }
            }
        }
    }
    
    
    
}

