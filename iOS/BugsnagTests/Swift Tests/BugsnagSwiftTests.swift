//
//  BugsnagSwiftTests.swift
//  Tests
//
//  Created by Robin Macharg on 05/02/2020.
//  Copyright © 2020 Bugsnag. All rights reserved.
//
//  Swift unit tests of global Bugsnag behaviour

import XCTest

class BugsnagSwiftTests: XCTestCase {

    /**
     * Confirm that the method is exposed to Swift correctly
     */
    func testAddMetadataToSectionIsExposedToSwiftCorrectly() {
        do {
            if let configuration = try BugsnagConfiguration(DUMMY_APIKEY_32CHAR_1) {
                Bugsnag.start(with: configuration)
                Bugsnag.addMetadata("mySection1", key: "myKey1", value: "myValue1")
                
                let exception1 = NSException(name: NSExceptionName(rawValue: "exception1"), reason: "reason1", userInfo: nil)
                
                Bugsnag.notify(exception1) { (event) in
                    // Arbitrary test, replicating the ObjC one
                    let value = (event.metadata["mySection1"] as! [String : Any])["myKey1"] as! String
                    XCTAssertEqual(value, "myValue1")
                }
            }
        }
        catch let e as NSError {
            print(e)
        }
    }
}