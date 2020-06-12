//
//  Copyright © 2020 Peter Barclay. All rights reserved.
//

import Foundation
import PBBase32

enum HOTPKeyDecoderError: Error {
    case invalidKey
}

public enum HOTPKeyDecoder {
    public static func decode(_ encodedKey: String) throws -> Data {
        guard let data = encodedKey.data(using: .ascii) else {
            throw HOTPKeyDecoderError.invalidKey
        }
        
        return try PBBase32.base32Decode(data: data)
    }
}

