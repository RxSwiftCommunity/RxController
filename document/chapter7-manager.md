# Chapter 7: Manager classes

Using manager classes is recommended for common business logic and API calling.
**A manager class should be defined with `final class` beacuse it should not be extened.**

```swift
final class UserManager {

    static let shared = UserManager()
    
    private init() {
        // Do something here...
    }
    
}
```

**The singleton pattern is recommended for the manager class.**
To hide disable the `init` method of the manager class, using a `private init()` method is recommended.

