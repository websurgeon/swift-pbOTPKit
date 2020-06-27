//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//
//  https://tools.ietf.org/rfc/rfc4226.txt
//

import Foundation
import CommonCrypto

public enum HOTPGenerator {
    
    public static func generate(
        encodedKey: String,
        counter: Int,
        digits: Int = 6
    ) throws -> String {
        let decodedKey = try HOTPKeyDecoder.decode(encodedKey)

        return generate(key: decodedKey, counter: counter, digits: digits)
    }
    
    public static func generate(
        key: Data,
        counter: Int,
        digits: Int = 6
    ) -> String {
        let hmac = generateHmacSha1(
            key: key as NSData,
            message: createMessage(from: counter))
                
        return stringCode(from: hmac, fixedLength: digits)
    }
}

// MARK: Helpers

extension HOTPGenerator {
    
    static func createMessage(from counter: Int) -> NSData {
        var counterValue = UInt(counter).bigEndian

        let messageLength = MemoryLayout.size(ofValue: counterValue)
        
        return Data(bytes: &counterValue, count: messageLength) as NSData
    }

    static func generateHmacSha1(key: NSData, message: NSData) -> [UInt8] {
        var hmac = [UInt8](repeating: 0, count: 20)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1),
               key.bytes, key.length,
               message.bytes, message.length,
               &hmac)

        return hmac
    }

    static func findInitialByteOffset(for hmac: [UInt8]) -> Int {
        return Int(hmac[hmac.count - 1] & 0xf)
    }

    static func binaryCode(from hmac: [UInt8], at offset: Int) -> Int {
        let byte1 = Int(hmac[offset    ] & 0x7f) << 24
        let byte2 = Int(hmac[offset + 1] & 0xff) << 16
        let byte3 = Int(hmac[offset + 2] & 0xff) << 8
        let byte4 = Int(hmac[offset + 3] & 0xff)

        return byte1 | byte2 | byte3 | byte4
    }

    static func limit(_ binaryCode: Int, toDigits digits: Int) -> Int {
        return binaryCode % Int(pow(Double(10), Double(digits)))
    }
    
    static func stringCode(
        from decimalCode: Int,
        fixedLength digits: Int
    ) -> String {
        return String(format: "%0\(digits)i", decimalCode)
    }
    
    static func stringCode(
        from hmac: [UInt8],
        fixedLength digits: Int
    ) -> String {
        let offset = findInitialByteOffset(for: hmac)

        return stringCode(
            from: limit(binaryCode(from: hmac, at: offset), toDigits: digits),
            fixedLength: digits)
    }
}

