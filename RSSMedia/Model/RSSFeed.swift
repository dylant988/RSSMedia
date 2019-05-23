//
//  RSSFeed.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import Foundation
import SwiftyXMLParser

struct RSSFeed {
    
    var id : String
    var title: String
    var desc: String
    var pubDate : String
    var link : String
    var isSaved: Bool // If current feed item has been saved to Core Data
    
    // MARK: Provide custom date formatting method
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let dateFormatted = dateFormatter.string(from: date)
        return dateFormatted
    }
    
}

extension RSSFeed {
    
    // MARK: Mapping XML data
    init(feed: XML.Accessor.Element) {
        id = feed["guid"].text ?? ""
        title = feed["title"].text ?? ""
        desc = feed["description"].text ?? ""
        pubDate = feed["pubDate"].text ?? ""
        link = feed["link"].text ?? ""
        isSaved = false
    }
    
    static func parseRSSFeedItems(feeds: XML.Accessor) -> [RSSFeed] {
        var rssFeeds = [RSSFeed]()
        for feed in feeds {
            rssFeeds.append(RSSFeed.init(feed: feed))
        }
        return rssFeeds
    }
}
