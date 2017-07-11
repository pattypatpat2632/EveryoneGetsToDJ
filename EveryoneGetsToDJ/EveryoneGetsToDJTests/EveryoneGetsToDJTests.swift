//
//  EveryoneGetsToDJTests.swift
//  EveryoneGetsToDJTests
//
//  Created by Patrick O'Leary on 6/7/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import XCTest
@testable import EveryoneGetsToDJ
import PromiseKit

class EveryoneGetsToDJTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testObserveTracks() {
        let firExpectation = expectation(description: "expect return from observe function")
        let firManager = FirebaseManager.sharedInstance
        firManager.observe(jukebox: "-KnZjudS6PoKyQFaQU5M").then { jukebox -> String in
            XCTAssertTrue(jukebox.tracks.count == 1, "Should observe one track within test jukebox")
            firExpectation.fulfill()
            return "Done"
        }.catch { error in
            
        }
        waitForExpectations(timeout: 20) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
