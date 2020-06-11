//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest
@testable import PBOTPKit

final class PBOTPKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PBOTPKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
