//
//  FeedListViewModel.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class FeedListViewModel {
    
    private var rssFeeds = [RSSFeed]()
    
    // MARK: Get data from APIHandler class
    func getRSSFeed(completionHandler: @escaping ()->()) {
        APIHandler().fetchRssFeeds { [weak self] (data, error) in
            DispatchQueue.main.async {
                if let feeds = data {
                    self?.rssFeeds = feeds
                    completionHandler()
                } else {
                    NotificationBanner(subtitle: error?.localizedDescription, style: .warning).show()
                }
            }
        }
    }
    
    // MARK: Provide number of rows in section to table view
    func getRowNum() -> Int {
        return rssFeeds.count
    }
    
    // MARK: Provide feed object to table view
    func getFeed(at: Int) -> RSSFeed {
        return rssFeeds[at]
    }
    
    // MARK: Check if feed is not existing in Core Data, then save it.
    func saveSelectedFeed(index: Int, completionHandler: @escaping (Bool)->()) {
        if appDelegate.fetchOneFeed(feedId: rssFeeds[index].id) == nil {
            appDelegate.saveCurrentFeed(rssFeed: rssFeeds[index])
            NotificationBanner(subtitle: NSLocalizedString("Feed Saved", comment: ""), style: .success).show()
            completionHandler(false)
        } else {
            completionHandler(true)
        }
    }
    
}
