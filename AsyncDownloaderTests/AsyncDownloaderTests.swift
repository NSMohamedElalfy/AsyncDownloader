//
//  AsyncDownloaderTests.swift
//  AsyncDownloaderTests
//
//  Created by NSMohamedElalfy on 10/30/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import XCTest
@testable import AsyncDownloader

class AsyncDownloaderTests: XCTestCase {
    
    var vc:MainCollectionViewController!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        vc = nav.topViewController as! MainCollectionViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAsyncDownloading() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = self.expectation(description: "asynchronous request")
        AsyncDownloader.shared.download("https://pixabay.com/api/", parameters: ["key":"3644469-0fdfa9298029a80a49e59659a",
                                                                             "q" : "Paris",
                                                                             "lang" : "en",
                                                                             "image_type" : "all",
                                                                             "per_page" : "20"]) { (result:Results) in
                                                                                switch result {
                                                                                case let .success(response) :
                                                                                    XCTAssertNotNil(response.getJSON(), "downloader failed to get JSON data")
                                                                                    if let json = response.getJSON() {
                                                                                        let hits = json["hits"] as! [[String:AnyObject]]
                                                                                        let samplePhoto = Photo(dictionary: hits[3])
                                                                                        AsyncDownloader.shared.download(samplePhoto.previewURL, onCompletion: { (r:Results) in
                                                                                            switch r {
                                                                                            case let .success(response):
                                                                                                XCTAssertNotNil(response.getUIImage(), "downloader failed to get UIImage data")
                                                                                            case let .failure(error):
                                                                                                XCTAssertNil(error, "error on download UIImage")
                                                                                            }
                                                                                        })
                                                                                    }
                                                                                case let .failure(error):
                                                                                    XCTAssertNil(error, "error on download JSON")
                                                                                }
                                                                                expectation.fulfill()
            
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
