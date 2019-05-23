//
//  APIHandlerTest.swift
//  RSSMediaTests
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import XCTest
import SwiftyXMLParser
@testable import RSSMedia

class APIHandlerTest: XCTestCase {
    
    var mockSession: URLSessionMock!
    var apiHandler: APIHandler!

    override func setUp() {
        mockSession = URLSessionMock()
        apiHandler = APIHandler(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        apiHandler = nil
    }

    func testFetchFeedAPI() {
        apiHandler.fetchRssFeeds { _,_ in  }
        XCTAssertEqual(mockSession.isAPIGetCalled, true)
    }
    
    func makeStub() -> [RSSFeed] {
        
        let sample = """
        <rss version="2.0"><channel><item><link>https://www.techrepublic.com/article/how-to-activate-and-use-the-built-in-windows-10-back-up-feature/#ftag=RSS56d97e7</link><title>How to activate and use the built-in Windows 10 back-up feature</title><description>Criminal activity targeting personal computers continues to grow at an alarming rate. Even the most basic of back-up systems can prevent future headaches.</description><pubDate>Wed, 22 May 2019 15:13:29 +0000</pubDate></item></channel></rss>
        """
        
        let xml = try! XML.parse(sample)
        let channel = xml["rss", "channel"]
        let item = channel["item"]
        return RSSFeed.parseRSSFeedItems(feeds: item)
    }
    
    func testStubbedAPIFeedNum() {
        let rssFeeds = makeStub()
        XCTAssertEqual(rssFeeds.count, 1)
    }
    
    func testStubbedAPIFeedTitle() {
        let rssFeeds = makeStub()
        let title = rssFeeds.first?.title
        XCTAssertEqual(title, "How to activate and use the built-in Windows 10 back-up feature")
    }
    

}
