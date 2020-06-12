//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest
import PBOTPKit

final class PBOTPKitTests: XCTestCase {
    func test_HOTPGenerator_isPublic() {
        _ = HOTPGenerator.self
    }
}
