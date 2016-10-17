//
//  ConfigKey.swift
//  RemoteConfigPlayground
//
//  Created by Suguru Kishimoto on 10/15/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation

public class ConfigKeys {
    private init() {}
}

public class ConfigKey<T>: ConfigKeys {
    let _key: String
    public init(_ key: String) {
        self._key = key
        super.init()
    }
}

extension ConfigKey: Hashable {
    public var hashValue: Int {
        return _key.hashValue
    }
}

public func == <Value>(lhs: ConfigKey<Value>, rhs: ConfigKey<Value>) -> Bool {
    return lhs._key == rhs._key
}
