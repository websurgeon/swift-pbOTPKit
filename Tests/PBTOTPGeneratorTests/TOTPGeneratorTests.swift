//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest
import PBTOTPGenerator

final class TOTPGeneratorTests: XCTestCase {
    private let key = "12345678901234567890".data(using: .utf8)!
    
    private let encodedKey = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"

    private let date = Date(timeIntervalSince1970: 1591997790) // 2020-06-12 21:36:30 +0000
    
    private let expectedCodes = [
        "871676", "246446", "601311", "999073", "191462",
        "026575", "542769", "908729", "769919", "295356"] // 30 seconds apart
    
    private let digits = 6
    
    func test_generateForEncodedKey() throws {
        try expectedCodes
            .enumerated()
            .map {
                (
                    date: Date(timeInterval: TimeInterval($0.offset * 30), since: date),
                    expectedCode: $0.element
                )
            }
            .forEach {
                
            let code = try TOTPGenerator.generate(
                    encodedKey: encodedKey,
                    date: $0.date,
                    digits: digits)
                
                XCTAssertEqual(code, $0.expectedCode)
        }
    }
    
    func test_generateForKey() {
        expectedCodes
            .enumerated()
            .map {
                (
                    date: Date(timeInterval: TimeInterval($0.offset * 30), since: date),
                    expectedCode: $0.element
                )
            }
            .forEach {
                
            let code = TOTPGenerator.generate(
                    key: key,
                    date: $0.date,
                    digits: digits)
                
                XCTAssertEqual(code, $0.expectedCode)
        }
    }
}
