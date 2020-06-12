# PBOTPKit

A Swift implemention of HOTP and TOTP

HOTP: HMAC-Based One-Time Password Algorithm (RFC-4226 )

TOTP: Time-Based One-Time Password Algorithm (RFC-6238 )

### HOTP Usage:

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

### TOTP Usage:

Using raw key data:

```swift

let keyData = "12345678901234567890".data(using: .utf8)!

let date = Date() // 2020-06-12 21:36:30 +0000

let code = HOTPGenerator.generate(key: keyData, date: date) // "871676"

```
Using Google Authenticator Base32 encoded key string:

```swift

let encodedKey = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ" // Base32 "12345678901234567890"

let date = Date() // 2020-06-12 21:36:30 +0000

let code = HOTPGenerator.generate(encodedKey: encodedKey, date: date) // "871676"

```

