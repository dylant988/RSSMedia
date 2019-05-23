//
//  APIHandler.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import Foundation
import SwiftyXMLParser

typealias FeedCompltionClosure = ((Data?, URLResponse?, Error?)-> Void)
protocol FeedInfoProtocol {
    func performTaskWithUrl(url: URL, completionHandler: @escaping FeedCompltionClosure)
}

extension URLSession: FeedInfoProtocol {
    func performTaskWithUrl(url: URL, completionHandler: @escaping FeedCompltionClosure) {
        
        dataTask(with: url, completionHandler: completionHandler)
            .resume()
    }
}

final class APIHandler {
    
    // MARK: Handle errors
    enum RSSFeedError: Error {
        case inCorrectUrl
        case failedResponse
        case timeout
        case paarsingError
        
        var localizedDescription: String {
            switch self {
            case .inCorrectUrl: return NSLocalizedString("Url is not correct.", comment: "")
            case .failedResponse: return NSLocalizedString("Could not receive data from server.", comment: "")
            case .timeout: return NSLocalizedString("Time out in request.", comment: "")
            case .paarsingError: return NSLocalizedString("Error during parsing.", comment: "")
            }
        }
    }
    
    let session: FeedInfoProtocol
    init(session: FeedInfoProtocol = URLSession.shared) {
        
        self.session = session
    }
    
    // MARK: Fetch API feeds
    func fetchRssFeeds(completionHandler: @escaping (_ orderArray: [RSSFeed]?, _ error: RSSFeedError?) -> Void) {
        
        guard let url = URL(string: apiURL) else {
            completionHandler(nil, .inCorrectUrl)
            return
        }
        session.performTaskWithUrl(url: url) { (dataObj, repoObj, error) in
            
            guard let data = dataObj else {
                completionHandler(nil, .failedResponse)
                return
            }
            let obj = XML.parse(data)["rss"]
            let channel = obj["channel"]
            let items = channel["item"]
            let rssFeeds = RSSFeed.parseRSSFeedItems(feeds: items)
            completionHandler(rssFeeds, nil)
        }
        
        
    }
}
