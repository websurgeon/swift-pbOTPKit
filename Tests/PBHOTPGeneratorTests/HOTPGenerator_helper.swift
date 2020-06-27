//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import XCTest
@testable import PBHOTPGenerator

final class HOTPGenerator_helperTests: XCTestCase {
    
    let createMessage = HOTPGenerator.createMessage
    
    let generateHmacSha1 = HOTPGenerator.generateHmacSha1
    
    let findInitialByteOffset = HOTPGenerator.findInitialByteOffset
    
    let binaryCode = HOTPGenerator.binaryCode
    
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
    
    // MARK: binaryCode
    
    func test_binaryCode_shouldReturnUnsignedValueOf4BytesFromOffset() {
        let hmac: [UInt8] = [
            0xff, 0xfe, 0xfd, 0xfc,
            0xfb, 0xfa, 0xf9, 0xf8,
            0xf7, 0xf6, 0xf5, 0xf4,
            0xf3, 0xf2, 0xf1, 0xf0,
            0xef, 0xee, 0xed, 0xec
        ]
        
        let removeSignBit = 0x7fffffff
        XCTAssertEqual(binaryCode(hmac, 0x00), 0xfffefdfc & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x01), 0xfefdfcfb & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x02), 0xfdfcfbfa & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x03), 0xfcfbfaf9 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x04), 0xfbfaf9f8 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x05), 0xfaf9f8f7 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x06), 0xf9f8f7f6 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x07), 0xf8f7f6f5 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x08), 0xf7f6f5f4 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x09), 0xf6f5f4f3 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x0a), 0xf5f4f3f2 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x0b), 0xf4f3f2f1 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x0c), 0xf3f2f1f0 & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x0d), 0xf2f1f0ef & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x0e), 0xf1f0efee & removeSignBit)
        XCTAssertEqual(binaryCode(hmac, 0x0f), 0xf0efeeed & removeSignBit)
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
fileprivate func ^^ (lhs: Int, rhs: Int) -> Int {
    return Int(pow(Double(lhs), Double(rhs)))
}

