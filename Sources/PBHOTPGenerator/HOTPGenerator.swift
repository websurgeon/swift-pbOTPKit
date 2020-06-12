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
        
        // Cast key data to NSData to use convenience methods to get bytes and length
        let keyData = key as NSData

        // Convert counter to big endian format
        var counterValue = UInt(counter).bigEndian
        
        // Create message for generating Hmac
        let messageLength = MemoryLayout.size(ofValue: counterValue)
        let message = Data(bytes: &counterValue, count: messageLength) as NSData

        // Create 20 byte container for hmac value
        var hmac = [UInt8](repeating: 0, count: 20)
        
        // Generate HMAC-SHA-1 value
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1),
               keyData.bytes, keyData.length,
               message.bytes, message.length,
               &hmac)
        
        // Find dynamic offset using low-order 4-bits of last byte
        let offset = Int(hmac[hmac.count - 1] & 0xf)
        
        // Construct 4-byte binary code value starting at offset
        let binaryCode: Int = (Int(hmac[offset    ] & 0x7f) << 24) |
                              (Int(hmac[offset + 1] & 0xff) << 16) |
                              (Int(hmac[offset + 2] & 0xff) << 8) |
                              (Int(hmac[offset + 3] & 0xff))
        
        // Limit code range to be 0..<10^{digits}
        let decimalCode = binaryCode % Int(pow(Double(10), Double(digits)))
        
        // return string code with fixed 'digits' length (padded with zeros)
        return String(format: "%0\(digits)i", decimalCode)
    }
}
