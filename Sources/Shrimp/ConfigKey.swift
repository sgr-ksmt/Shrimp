//
//  ConfigKey.swift
//  RemoteConfigPlayground
//
//  Created by Suguru Kishimoto on 10/15/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation

public class ConfigKeys {
    fileprivate init() {}
}

public class ConfigKey<T>: ConfigKeys {
    let _key: String
    public init(_ key: String) {
        self._key = key
        super.init()
    }
}

extension ConfigKey: Hashable {
    public static func == (lhs: ConfigKey, rhs: ConfigKey) -> Bool {
        return lhs._key == rhs._key
    }
    
    public var hashValue: Int {
        return _key.hashValue
    }
}
