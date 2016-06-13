//
//  ItemStoreChallengeTests.swift
//  ItemStoreChallengeTests
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import XCTest
@testable import ItemStoreChallenge

class ItemStoreChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testImageHalfsizing()
    {
        let image = UIImage(named: "cat_curlup3")
        let beforeWidth = image!.size.width
        let beforeHeight = image!.size.height
        let newImage = image!.halfSizeImage()
        let newWidth = newImage.size.width
        let newHeight = newImage.size.height
        
        XCTAssert(beforeWidth == newWidth * 2)
        XCTAssert(beforeHeight == newHeight * 2)
    }
}
