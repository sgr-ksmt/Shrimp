![Language](https://img.shields.io/badge/language-Swift%203-orange.svg)  

# Shrimp
Shrimp is a Firebase-RemoteConfig helper library.

```swift
extension ConfigKeys {
    static let labelText = ConfigKey<String>("label_text")
}

class ViewController: UIViewController {
    @IBOutlet private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        Shrimp.shared.developerMode = true

        Shrimp.shared.config[.labelText] = "Default Text"
        label.text = Shrimp.shared.config[.labelText]

        Shrimp.shared.fetch() { [weak self] result in
            switch result {
            case .success(let config):
                self?.label.text = config[.labelText]
            case .failure(let error):
                print(error)
            }
        }
    }
}
```

## :star: Features
- **Type safe**. :sparkles:
- Easy to set default value
- FIRRemoteConfig wrapper.
- **Custom type available** :sparkles:
- Namespace support.(experimental, future function)

---

## :muscle: Usage

### Define `ConfigKey`

Define `ConfigKey` as `ConfigyKeys`'s static variable.
```swift
extension ConfigKeys {
    static let labelText = ConfigKey<String>("label_text")
}
```

Then you can now use the Shrimp shortcut to access those values:

```swift
Shrimp.shared.config[.labelText] = "Default Text"
Shrimp.shared.config[.labelText] = 123 // compile error
let text = Shrimp.shared.config[.labelText] // text is `String`
```

#### Before/After :eyes:

```swift
// Before
let text = FIRRemoteConfig.remoteConfig()["label_text"].stringValue ?? ""

// After
let text = Shrimp.shared.config[.labelText]
```

### Set default value to RemoteConfig
If you create `ConfigKey`, then you can easily set default value to RemoteConfig.

```swift
Shrimp.shared.config[.labelText] = "Default Text"
```

### Fetch config :earth_americas:
Fetch latest config from firebase.

```swift
Shrimp.shared.fetch() { [weak self] result in
    switch result {
    case .success(let config):
        self?.label.text = config[.labelText] // get `String` value
    case .failure(let error):
        print(error)
    }
}
```

`result` is enum type below:

```swift
public enum Result {
    case success(RemoteConfig)
    case failure(Error?)
}
```

#### Fetch config (with expiratoin) :clock3:

- Set expiration to argument.

```swift
// fetch with expiration (5 min)
Shrimp.shared.fetch(withExpirationDuration: 60.0 * 5.0) { [weak self] result in
    // ...
}
```

- Set expiration as default value. (default is 12 hours)

```swift
// change expiration to 10 min
Shrimp.shared.defaultExpirationDuration = 60 * 10
// fetch with expiration (10 min)
Shrimp.shared.fetch() { [weak self] result in
    // ...
}
```

### Set DeveloperMode (if needed) : :warning:
If you use `Developer Mode`, set `Shrimp.shared.developerMode` to true.

```swift
Shrimp.shared.developerMode = true

// equal to below:
let remoteConfigSettings = FIRRemoteConfigSettings()
remoteConfigSettings.developerModeEnabled = true
FIRRemoteConfig.remoteConfig().configSettings = remoteConfigSettings
```

### Supported types :four_leaf_clover:
| Optional variant | Non-optional variant | Default value |
|:-----------------|:---------------------|:--------------|
| Int?             | Int                  | 0             |
| Float?           | Float                | 0.0           |
| Double?          | Double               | 0.0           |
| CGFloat?         | CGFloat              | 0.0           |
| NSNumber?        | ---                  | nil           |
| String?          | String               | ""            |
| Bool?            | Bool                 | false         |
| Data?            | Data                 | Data()        |
| URL?             | ---                  | nil           |

---

## :muscle::muscle: Advanced Usage
### Custom types
You can easily use custom type(e.g. `UIColor`, `enum` , etc...) by extending `RemoteConfig` and define **subscript**.

#### Example (`enum`)

- Definition

```swift
enum SampleType: Int {
    case a, b, none
}

extension ConfigKeys {
    static let testType = ConfigKey<SampleType>("test_type")
}

extension RemoteConfig {
    subscript (key: ConfigKey<SampleType>) -> SampleType {
        get {
            return int(for: key).flatMap(SampleType.init) ?? .none
        }
        set {
            set(key: key, value: newValue.rawValue)
        }
    }
}
```

- Usage

```swift
// Set default value
Shrimp.shared.config[.testType] = .none

// Get value as `SampleType`
switch Shrimp.shared.config[.testType] {
    case .a:
        // ...
    case .b:
        // ...
    case .none:
        // ...
}
```

#### Example (UIColor)
!! screenshot  
Try UIColor <-> String(hex) using [UIColor-Hex-Swift](https://github.com/yeahdongcn/UIColor-Hex-Swift)

- Definition

```swift
import UIColor_Hex_Swift

extension ConfigKeys {
    static let backgroundColor = ConfigKey<UIColor?>("test_bg")
}

extension RemoteConfig {
    subscript (key: ConfigKey<UIColor?>) -> UIColor? {
        get {
            return string(for: key).flatMap { UIColor.init($0) }
        }
        set {
            set(key: key, value: newValue?.hexString())
        }
    }
}
```

- Usage

```swift
// Set default value
Shrimp.shared.config[.backgroundColor] = .white

// Get value as UIColor
self.view.backgroundColor = Shrimp.shared.config[.backgroundColor]
```

## Demo :ship:
- (1) Clone this project
- (2) move to `Demo/`
- (3) run `pod install`
- (4) put `GoogleService-Info.plist` to `Demo/`
- (5) open project and Run!

## Requirements :traffic_light:
- Xcode 8.0+
- Swift 3.0+
- iOS 8+

## Installation :earth_americas:
### Cocoapods :construction:
**Coming Soon.**  
<br />
This library can't install via cocoapods because of `Firebase` libraries are static library.  
If Firebase libraries are available as dynamic library, then I prepare `podspec` and register to CocoaPods.

- [Related issue(CocoaPods)](https://github.com/CocoaPods/CocoaPods/issues/5789)

### Manual :arrow_left::arrow_left:
- (1) Add the following to the pod file, then run `Pods install`

```ruby
pod 'Firebase'
pod 'Firebase/RemoteConfig'
```

- (2) Download or clone this project. **[Download sources](https://github.com/sgr-ksmt/Shrimp/releases/download/0.1.0/Shrimp.zip)**
- (3) Put `Sources/Shrimp/*.swift` in your project.  
(need `Shrimp.swift`, `ConfigKey.swift`, `RemoteConfig.swift`)

## Communication :sunny:
- If you found a bug, please open an issue. :bow:
- Also, if you have a feature request, please open an issue. :thumbsup:
- If you want to contribute, submit a pull request.:muscle:

## Special Thanks :bow:
- [SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults)
- [Firebase](https://firebase.google.com/)

## License
**Shrimp** is under BSD license. See the [LICENSE](LICENSE) file for more info.
