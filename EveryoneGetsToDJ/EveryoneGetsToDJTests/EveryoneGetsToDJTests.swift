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
            let trackInstantiated = (firManager.jukebox?.tracks[0].name == "Drunken Lullabies" && firManager.jukebox?.tracks[0].uri == "spotify:track:3nhJpxZXEQTsZwrDUihXQf")
            XCTAssertTrue(trackInstantiated, "Firebase Manager Shared Instance Jukebox should have instantiated tracks")
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
    
    func testCoreData() {
        let cdManager = CoreDataManager.sharedInstance
        let firstExpectation = expectation(description: "Expect to fetch favorite track from core data manager")
        let secondExpecation = expectation(description: "Expect to fetch 0 favorite tracks from core data manager")
        
        let track = Track(name: "Name", albumID: "Album ID", albumName: "Album Name", artistID: "Arrist ID", artistName: "Artist Name", imageURL: "Image URL", image: nil, uri: "URI", selectorName: "Selector Name", selectorID: "Selector ID", selectedDate: nil)
        cdManager.save(track: track)
        cdManager.fetchFavoriteTracks().then{ tracks -> String in
            XCTAssertTrue(tracks.count == 1, "There should be one saved track")
            XCTAssert(tracks[0].name == "Name", "Track should have a name property")
            firstExpectation.fulfill()
            return "Done"
        }.catch {_ in 
                
        }
        
        
        cdManager.delete(track: track)
        
        
        cdManager.fetchFavoriteTracks().then{ tracks -> String in
           
            XCTAssertTrue(tracks.isEmpty, "There should be 0 saved tracks")
            secondExpecation.fulfill()
            return "Done"
        }.catch {_ in 
            
        }
        
        waitForExpectations(timeout: 20) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
