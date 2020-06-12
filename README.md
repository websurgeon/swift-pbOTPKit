# PBOTPKit

A Swift implemention of RFC-4226 HOTP HMAC-Based One-Time Password Algorithm.

### Usage:

Using raw key data:

```swift

let keyData = "12345678901234567890".data(using: .utf8)!

let code = HOTPGenerator.generate(key: keyData, counter: 1) // "287082"

```
Using Google Authenticator Base32 encoded key string:

```swift

let encodedKey = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ" // Base32 "12345678901234567890"

let code = HOTPGenerator.generate(encodedKey: encodedKey, counter: 1) // "287082"

```

