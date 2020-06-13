//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest
@testable import PBHOTPGenerator

final class HOTPGenerator_helperTests: XCTestCase {
    
    let createMessage = HOTPGenerator.createMessage
    
    let generateHmacSha1 = HOTPGenerator.generateHmacSha1
    
    let findInitialByteOffset = HOTPGenerator.findInitialByteOffset
    
    // MARK: createMessage
    
    func test_createMessage_shouldReturnBigEndianDataRepresentation() {
        
        XCTAssertEqual(
            createMessage(1),
            Data([
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x01
            ]) as NSData)
        
        XCTAssertEqual(
            createMessage(1234567890),
            Data([
                0x00, 0x00, 0x00, 0x00,
                0x49, 0x96, 0x02, 0xd2
            ]) as NSData)
    }
    
    // MARK: generateHmacSha1
    
    func test_generateHmacSha1_shouldReturnCorrectHmacData() {
        // https://tools.ietf.org/html/rfc2202
        // 3. Test Cases for HMAC-SHA-1
        // test_case =     5
        // key =           0x0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c
        // key_len =       20
        // data =          "Test With Truncation"
        // data_len =      20
        // digest =        0x4c1a03424b55e07fe7f27be1d58bb9324a9a5a04
        
        let key = Data([
            0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
            0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
            0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
            0x0c, 0x0c, 0x0c, 0x0c, 0x0c
        ]) as NSData
        
        let message = "Test With Truncation".data(using: .utf8)! as NSData

        let hmac = generateHmacSha1(key, message)
        
        XCTAssertEqual(hmac, [
             0x4c, 0x1a, 0x03, 0x42, 0x4b,
             0x55, 0xe0, 0x7f, 0xe7, 0xf2,
             0x7b, 0xe1, 0xd5, 0x8b, 0xb9,
             0x32, 0x4a, 0x9a, 0x5a, 0x04
        ])
    }
    
    func test_generateHmacSha1_shouldReturn20Bytes() {
        let expectedHmacLength = 20
        
        let randomData: () -> NSData = {
            let length = Int(arc4random_uniform(1_000))
            let bytes = [UInt32](repeating: 0, count: length).map { _ in arc4random() }
            return Data(bytes: bytes, count: bytes.count) as NSData
        }
        
        (0..<10).forEach { _ in
            let key = randomData()
            let message = randomData()
            let hmacLength = generateHmacSha1(key, message).count
            XCTAssertEqual(
                hmacLength,
                expectedHmacLength,
                "key: \(key), message: \(message)")
        }
    }
    
    // MARK: findInitialByteOffset

    func test_findInitialByteOffset_shouldReturnValueFromLast4Bits() {
        XCTAssertEqual(
            findInitialByteOffset([
                0x1f, 0x86, 0x98, 0x69, 0x0e,
                0x02, 0xca, 0x16, 0x61, 0x85,
                0x50, 0xef, 0x7f, 0x19, 0xda,
                0x8e, 0x94, 0x5b, 0x55, 0x5a
            ]),
            0x0a)
        
        XCTAssertEqual(
            findInitialByteOffset([
                0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0xff
            ]),
            0x0f)
        
        XCTAssertEqual(
        findInitialByteOffset([0xab]), 0x0b)
    }
}



