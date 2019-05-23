//
//  URLSessionMock.swift
//  RSSMediaTests
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import Foundation
@testable import RSSMedia

class URLSessionMock: FeedInfoProtocol {
    
    var isAPIGetCalled = false
    
    var requestedURL: URL?
    func performTaskWithUrl(url: URL, completionHandler: @escaping FeedCompltionClosure) {
        
        requestedURL = url
        isAPIGetCalled = true
        let data = "test data".data(using: .utf8)
        completionHandler(data, nil, nil)
    }
}
