//
//  PolyTests.swift
//  PolyTests
//
//  Created by Sidney Kochman on 11/6/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import XCTest
@testable import Poly

class PolyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecoderString() {
		// Test DecoderString turning HTML entities into normal characters.
		let cases = [
			"professor&rsquo;s honor": "professor’s honor",
			"MEN&rsquo;S AND WOMEN&rsquo;S TEAMS": "MEN’S AND WOMEN’S TEAMS",
			"4&ndash;1": "4–1"
		]
		for (input, output) in cases {
			let decoder = DecoderString(input)
			XCTAssertEqual(decoder.decode(), output)
		}
    }
}
