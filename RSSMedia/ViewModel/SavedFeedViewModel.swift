//
//  SavedFeedViewModel.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class SavedFeedViewModel {
    
    private var rssFeeds = [RSSFeed]()
    
    // MARK: Get data from Core Data
    func getRSSFeed(completionHandler :@escaping ()->()) {
        
        if let feeds = appDelegate.fetchSavedFeed() {
            self.rssFeeds = feeds
        } else {
            NotificationBanner(subtitle: NSLocalizedString("No data", comment: ""), style: .warning).show()
        }
        completionHandler()
    }
    
    // MARK: Provide number of rows in section to table view
    func getRowNum() -> Int {
        return rssFeeds.count
    }
    
    // MARK: Provide feed object to table view
    func getFeed(at: Int) -> RSSFeed {
        return rssFeeds[at]
    }
    
    // MARK: Remove the selected feed from Core Data and viewModel.
    func removeSelectedFeed(index: Int, completionHandler: @escaping ()->()) {
        appDelegate.deleteSelectedFeed(feedId: rssFeeds[index].id)
        rssFeeds.remove(at: index)
        completionHandler()
    }
    
}
