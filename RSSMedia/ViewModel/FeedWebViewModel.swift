//
//  FeedWebViewModel.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import Foundation

struct FeedWebViewModel {
    
    var feedURL : String?
    
    // MARK: Provide feed link for web view
    func getFeedURL() -> String {
        guard let url = feedURL else { return "" }
        return url
    }
}
