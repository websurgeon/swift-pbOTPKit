//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest
import PBHOTPGenerator

final class HOTPGeneratorTests: XCTestCase {
    
    func test_generateForEncodedKey_sample1() throws {
        let sample = TestVectors.sample1
        
        try sample.values.forEach {
            
            let code = try HOTPGenerator.generate(
                encodedKey: sample.encodedKey,
                counter: $0.counter,
                digits: sample.digits)
            
            XCTAssertEqual(code, $0.expected)
        }
    }
    
    func test_generateForEncodedKey_sample2() throws {
        let sample = TestVectors.sample2
        
        try sample.values.forEach {
            
            let code = try HOTPGenerator.generate(
                encodedKey: sample.encodedKey,
                counter: $0.counter,
                digits: sample.digits)
            
            XCTAssertEqual(code, $0.expected)
        }
    }
    
    func test_generateForKey_sample1() {
        let sample = TestVectors.sample1
        
        sample.values.forEach {
            
            let code = HOTPGenerator.generate(
                key: sample.key,
                counter: $0.counter,
                digits: sample.digits)
            
            XCTAssertEqual(code, $0.expected)
        }
    }
    
    func test_generateForKey_sample2() {
        let sample = TestVectors.sample2

        sample.values.forEach {
            
            let code = HOTPGenerator.generate(
                key: sample.key,
                counter: $0.counter,
                digits: sample.digits)

            XCTAssertEqual(code, $0.expected)
        }
    }
}

enum TestVectors {
    typealias Sample = (
        key: Data,
        encodedKey: String,
        values: [(counter: Int, expected: String)],
        digits: Int
    )
    
    static let sample1: Sample = (
           key: "12345".data(using: .utf8)!,
           encodedKey: "GEZDGNBV",
           values: [
               "734055", "662488", "289363", "703348", "496930",
               "125318", "241932", "128557", "292893", "498804"
            ]
               .enumerated()
               .map { (counter: $0.offset, expected: $0.element) },
           digits: 6)

    static let sample2: Sample = (
           key: "12345678901234567890".data(using: .utf8)!,
           encodedKey: "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ",
           values: [
               "755224", "287082", "359152", "969429", "338314",
               "254676", "287922", "162583", "399871", "520489"
            ]
               .enumerated()
               .map { (counter: $0.offset, expected: $0.element) },
           digits: 6)
}
