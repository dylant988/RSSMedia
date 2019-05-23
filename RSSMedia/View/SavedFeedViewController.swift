//
//  SavedFeedViewController.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import UIKit

class SavedFeedViewController: BaseViewController {

    @IBOutlet weak var savedFeedTableView: UITableView!
    var viewModel : SavedFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedFeedTableView.reloadData() // Avoid table view cell from being selected
    }

    // MARK: Initialize all instances
    func initialize() {
        initializeLocalization()
        viewModel = SavedFeedViewModel()
        setupTableView()
        viewModel.getRSSFeed { [weak self] in
            self?.savedFeedTableView.reloadData()
        }
    }
    
    func initializeLocalization() {
        title = NSLocalizedString(SavedFeedViewTitle, comment: "")
    }
    
    func setupTableView() {
        savedFeedTableView.estimatedRowHeight = CGFloat(rowHeight)
        savedFeedTableView.rowHeight = UITableView.automaticDimension // Set table view adaptive row height
        savedFeedTableView.delegate = self
        savedFeedTableView.dataSource = self
        savedFeedTableView.tableFooterView = UIView() // Remove the separators after the last feed
    }
}

extension SavedFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowNum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedFeedCell") as? SavedFeedTableViewCell else { return UITableViewCell() }
        let feed = viewModel.getFeed(at: indexPath.row)
        let date = feed.formatDate(dateString: feed.pubDate)
        cell.titleLabel.text = feed.title
        cell.descLabel.text = feed.desc
        cell.dateLabel.text = date
        cell.removeBtn.setTitle(NSLocalizedString("REMOVE", comment: ""), for: .normal)
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeCurrentFeed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "savedFeedWebSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webViewController = segue.destination as? FeedWebViewController else { return }
        webViewController.viewModel = FeedWebViewModel(feedURL: viewModel.getFeed(at: savedFeedTableView.indexPathForSelectedRow!.row).link)
        
    }
    
    // MARK: Pop up an alert when users attempt to remove a feed
    @objc func removeCurrentFeed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("You are going to remove this feed item", comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { (action) in
            self.viewModel.removeSelectedFeed(index: sender.tag) {
                DispatchQueue.main.async {
                    self.savedFeedTableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
        
}
