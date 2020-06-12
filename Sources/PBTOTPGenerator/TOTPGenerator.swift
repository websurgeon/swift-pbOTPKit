//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//
//  https://tools.ietf.org/rfc/rfc6238.txt
//

import Foundation
import CommonCrypto
import PBHOTPGenerator

public enum TOTPGenerator {
    public static func generate(
        encodedKey: String,
        date: Date,
        digits: Int = 6
    ) throws -> String {
        let decodedKey = try HOTPKeyDecoder.decode(encodedKey)

        return generate(key: decodedKey, date: date, digits: digits)
    }
    
    public static func generate(
        key: Data,
        date: Date,
        digits: Int = 6
    ) -> String {
        let counter = Int(date.timeIntervalSince1970 / 30)
        
        return HOTPGenerator.generate(key: key, counter: counter)
    }
}
