//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PBOTPKitTests.allTests),
    ]
}
#endif
