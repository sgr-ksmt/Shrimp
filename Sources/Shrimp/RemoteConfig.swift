//
//  RemoteConfig.swift
//  RemoteConfigPlayground
//
//  Created by Suguru Kishimoto on 10/15/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseRemoteConfig

public class RemoteConfig {
    fileprivate static let defaultNamespace = ""
    fileprivate var defaults: [String: [String: NSObject]] = [:]
    
    fileprivate lazy var remoteConfig: FIRRemoteConfig = FIRRemoteConfig.remoteConfig()
    
    public func set<T>(key: ConfigKey<T>, value: NSObject?, namespace: String = defaultNamespace) {
        if defaults[namespace] == nil {
            defaults[namespace] = [:]
        }
        defaults[namespace]?[key._key] = value
        updateConfig()
    }
    
    public func removeDefault(forKey key: String, namespace: String = defaultNamespace) {
        defaults[namespace]?[key] = nil
        updateConfig()
    }
    
    public func removeDefaults(forNamespace namespace: String) {
        defaults[namespace] = nil
        updateConfig()
    }
    
    public func removeAllDefaults() {
        defaults = [:]
        updateConfig()
    }
    
    private func updateConfig() {
        defaults.forEach { key, value in
            if key == RemoteConfig.defaultNamespace {
                remoteConfig.setDefaults(value)
            } else {
                remoteConfig.setDefaults(value, namespace: key)
            }
        }
    }
    
    public func string<T>(for key: ConfigKey<T>) -> String? {
        return remoteConfig.configValue(forKey: key._key).stringValue
    }
    
    public func string<T>(for key: ConfigKey<T>, namespace: String?) -> String? {
        return remoteConfig.configValue(forKey: key._key, namespace: namespace).stringValue
    }
    
    public func number<T>(for key: ConfigKey<T>) -> NSNumber? {
        return remoteConfig.configValue(forKey: key._key).numberValue
    }
    
    public func number<T>(for key: ConfigKey<T>, namespace: String?) -> NSNumber? {
        return remoteConfig.configValue(forKey: key._key, namespace: namespace).numberValue
    }
    
    public func int<T>(for key: ConfigKey<T>) -> Int? {
        return number(for: key)?.intValue
    }
    
    public func int<T>(for key: ConfigKey<T>, namespace: String?) -> Int? {
        return number(for: key, namespace: namespace)?.intValue
    }

    public func float<T>(for key: ConfigKey<T>) -> Float? {
        return number(for: key)?.floatValue
    }
    
    public func float<T>(for key: ConfigKey<T>, namespace: String?) -> Float? {
        return number(for: key, namespace: namespace)?.floatValue
    }

    public func double<T>(for key: ConfigKey<T>) -> Double? {
        return number(for: key)?.doubleValue
    }
    
    public func double<T>(for key: ConfigKey<T>, namespace: String?) -> Double? {
        return number(for: key, namespace: namespace)?.doubleValue
    }

    public func cgFloat<T>(for key: ConfigKey<T>) -> CGFloat? {
        return double(for: key).map { CGFloat.init($0) }
    }
    
    public func cgFloat<T>(for key: ConfigKey<T>, namespace: String?) -> CGFloat? {
        return double(for: key, namespace: namespace).map { CGFloat.init($0) }
    }
    
    public func bool<T>(for key: ConfigKey<T>) -> Bool {
        return remoteConfig.configValue(forKey: key._key).boolValue
    }
    
    public func bool<T>(for key: ConfigKey<T>, namespace: String?) -> Bool {
        return remoteConfig.configValue(forKey: key._key, namespace: namespace).boolValue
    }
    
    public func data<T>(for key: ConfigKey<T>) -> Data {
        return remoteConfig.configValue(forKey: key._key).dataValue
    }
    
    public func data<T>(for key: ConfigKey<T>, namespace: String?) -> Data {
        return remoteConfig.configValue(forKey: key._key, namespace: namespace).dataValue
    }
}

extension RemoteConfig {
    public func set<T>(key: ConfigKey<T>, value: String?, namespace: String = defaultNamespace) {
        set(key: key, value: value as NSString?, namespace: namespace)
    }
    
    public func set<T>(key: ConfigKey<T>, value: Int?, namespace: String = defaultNamespace) {
        set(key: key, value: value.map { NSNumber(value: $0) }, namespace: namespace)
    }

    public func set<T>(key: ConfigKey<T>, value: Float?, namespace: String = defaultNamespace) {
        set(key: key, value: value.map { NSNumber(value: $0) }, namespace: namespace)
    }

    public func set<T>(key: ConfigKey<T>, value: Double?, namespace: String = defaultNamespace) {
        set(key: key, value: value.map { NSNumber(value: $0) }, namespace: namespace)
    }

    public func set<T>(key: ConfigKey<T>, value: CGFloat?, namespace: String = defaultNamespace) {
        set(key: key, value: value.map { NSNumber(value: Double($0)) }, namespace: namespace)
    }

    public func set<T>(key: ConfigKey<T>, value: Bool?, namespace: String = defaultNamespace) {
        set(key: key, value: value.map { NSNumber(value: $0) }, namespace: namespace)
    }

    public func set<T>(key: ConfigKey<T>, value: Data?, namespace: String = defaultNamespace) {
        set(key: key, value: value.map(NSData.init), namespace: namespace)
    }

    public subscript (key: ConfigKey<String>) -> String {
        get { return string(for: key) ?? "" }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<String>, namespace: String) -> String {
        get { return string(for: key, namespace: namespace) ?? "" }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<String?>) -> String? {
        get { return string(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<String?>, namespace: String) -> String? {
        get { return string(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<NSNumber>) -> NSNumber {
        get { return number(for: key) ?? NSNumber(value: 0) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<NSNumber>, namespace: String) -> NSNumber {
        get { return number(for: key, namespace: namespace) ?? NSNumber(value: 0) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<NSNumber?>) -> NSNumber? {
        get { return number(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<NSNumber?>, namespace: String) -> NSNumber? {
        get { return number(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<Int>) -> Int {
        get { return int(for: key) ?? 0 }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Int>, namespace: String) -> Int {
        get { return int(for: key, namespace: namespace) ?? 0 }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<Int?>) -> Int? {
        get { return int(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Int?>, namespace: String) -> Int? {
        get { return int(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<Float>) -> Float {
        get { return float(for: key) ?? 0.0 }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Float>, namespace: String) -> Float {
        get { return float(for: key, namespace: namespace) ?? 0.0 }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<Float?>) -> Float? {
        get { return float(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Float?>, namespace: String) -> Float? {
        get { return float(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<Double>) -> Double {
        get { return double(for: key) ?? 0.0 }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Double>, namespace: String) -> Double {
        get { return double(for: key, namespace: namespace) ?? 0.0 }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<Double?>) -> Double? {
        get { return double(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Double?>, namespace: String) -> Double? {
        get { return double(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<CGFloat>) -> CGFloat {
        get { return cgFloat(for: key) ?? 0.0 }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<CGFloat>, namespace: String) -> CGFloat {
        get { return cgFloat(for: key, namespace: namespace) ?? 0.0 }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<CGFloat?>) -> CGFloat? {
        get { return cgFloat(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<CGFloat?>, namespace: String) -> CGFloat? {
        get { return cgFloat(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }

    public subscript (key: ConfigKey<Bool>) -> Bool {
        get { return bool(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Bool>, namespace: String) -> Bool {
        get { return bool(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<Bool?>) -> Bool? {
        get { return bool(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Bool?>, namespace: String) -> Bool? {
        get { return bool(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<Data>) -> Data {
        get { return data(for: key) }
        set { set(key: key, value: newValue) }
    }

    public subscript (key: ConfigKey<Data>, namespace: String) -> Data {
        get { return data(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<Data?>) -> Data? {
        get { return data(for: key) }
        set { set(key: key, value: newValue) }
    }
    
    public subscript (key: ConfigKey<Data?>, namespace: String) -> Data? {
        get { return data(for: key, namespace: namespace) }
        set { set(key: key, value: newValue, namespace: namespace) }
    }
    
    public subscript (key: ConfigKey<URL?>) -> URL? {
        get { return string(for: key).flatMap { URL.init(string: $0) } }
        set { set(key: key, value: newValue?.absoluteString) }
    }
}

// default value
extension RemoteConfig {
    public func defaultString<T>(for key: ConfigKey<T>, namespace: String? = nil) -> String? {
        return defaults[namespace ?? RemoteConfig.defaultNamespace]?[key._key] as? String
        //        not work yet (bug?)
        //        return remoteConfig.defaultValue(forKey: key._key, namespace: namespace)?.stringValue
    }
    
    public func defaultNumber<T>(for key: ConfigKey<T>, namespace: String? = nil) -> NSNumber? {
        return defaults[namespace ?? RemoteConfig.defaultNamespace]?[key._key] as? NSNumber
        //        not work yet (bug?)
        //        return remoteConfig.defaultValue(forKey: key._key, namespace: namespace)?.numberValue
    }
    
    public func defaultInt<T>(for key: ConfigKey<T>, namespace: String? = nil) -> Int? {
        return defaultNumber(for: key, namespace: namespace)?.intValue
    }
    
    public func defaultFloat<T>(for key: ConfigKey<T>, namespace: String? = nil) -> Float? {
        return defaultNumber(for: key, namespace: namespace)?.floatValue
    }
    
    public func defaultDouble<T>(for key: ConfigKey<T>, namespace: String? = nil) -> Double? {
        return defaultNumber(for: key, namespace: namespace)?.doubleValue
    }
    
    public func defaultCGFloat<T>(for key: ConfigKey<T>, namespace: String? = nil) -> CGFloat? {
        return defaultDouble(for: key, namespace: namespace).map { CGFloat.init($0) }
    }
    
    public func defaultBool<T>(for key: ConfigKey<T>, namespace: String? = nil) -> Bool? {
        return defaults[namespace ?? RemoteConfig.defaultNamespace]?[key._key] as? Bool
        //        not work yet (bug?)
        //        return remoteConfig.defaultValue(forKey: key._key, namespace: namespace)?.boolValue
    }
    
    public func defaultData<T>(for key: ConfigKey<T>, namespace: String? = nil) -> Data? {
        return defaults[namespace ?? RemoteConfig.defaultNamespace]?[key._key] as? Data
        //        not work yet (bug?)
        //        return remoteConfig.defaultValue(forKey: key._key, namespace: namespace)?.dataValue
    }
    
    public subscript (default key: ConfigKey<String>) -> String {
        get { return defaultString(for: key) ?? "" }
    }
    
    public subscript (default key: ConfigKey<String>, namespace: String) -> String {
        get { return defaultString(for: key, namespace: namespace) ?? "" }
    }
    
    public subscript (default key: ConfigKey<String?>) -> String? {
        get { return defaultString(for: key) }
    }
    
    public subscript (default key: ConfigKey<String?>, namespace: String) -> String? {
        get { return defaultString(for: key, namespace: namespace) }
    }

    public subscript (default key: ConfigKey<NSNumber>) -> NSNumber {
        get { return defaultNumber(for: key) ?? NSNumber(value: 0) }
    }
    
    public subscript (default key: ConfigKey<NSNumber>, namespace: String) -> NSNumber {
        get { return defaultNumber(for: key, namespace: namespace) ?? NSNumber(value: 0) }
    }

    public subscript (default key: ConfigKey<NSNumber?>) -> NSNumber? {
        get { return defaultNumber(for: key) }
    }
    
    public subscript (default key: ConfigKey<NSNumber?>, namespace: String) -> NSNumber? {
        get { return defaultNumber(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<Int>) -> Int {
        get { return defaultInt(for: key) ?? 0 }
    }
    
    public subscript (default key: ConfigKey<Int>, namespace: String) -> Int {
        get { return defaultInt(for: key, namespace: namespace) ?? 0 }
    }
    
    public subscript (default key: ConfigKey<Int?>) -> Int? {
        get { return defaultInt(for: key) }
    }
    
    public subscript (default key: ConfigKey<Int?>, namespace: String) -> Int? {
        get { return defaultInt(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<Float>) -> Float {
        get { return defaultFloat(for: key) ?? 0.0 }
    }
    
    public subscript (default key: ConfigKey<Float>, namespace: String) -> Float {
        get { return defaultFloat(for: key, namespace: namespace) ?? 0.0 }
    }
    
    public subscript (default key: ConfigKey<Float?>) -> Float? {
        get { return defaultFloat(for: key) }
    }
    
    public subscript (default key: ConfigKey<Float?>, namespace: String) -> Float? {
        get { return defaultFloat(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<Double>) -> Double {
        get { return defaultDouble(for: key) ?? 0.0 }
    }
    
    public subscript (default key: ConfigKey<Double>, namespace: String) -> Double {
        get { return defaultDouble(for: key, namespace: namespace) ?? 0.0 }
    }
    
    public subscript (default key: ConfigKey<Double?>) -> Double? {
        get { return defaultDouble(for: key) }
    }
    
    public subscript (default key: ConfigKey<Double?>, namespace: String) -> Double? {
        get { return defaultDouble(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<CGFloat>) -> CGFloat {
        get { return defaultCGFloat(for: key) ?? 0.0 }
    }
    
    public subscript (default key: ConfigKey<CGFloat>, namespace: String) -> CGFloat {
        get { return defaultCGFloat(for: key, namespace: namespace) ?? 0.0 }
    }
    
    public subscript (default key: ConfigKey<CGFloat?>) -> CGFloat? {
        get { return defaultCGFloat(for: key) }
    }
    
    public subscript (default key: ConfigKey<CGFloat?>, namespace: String) -> CGFloat? {
        get { return defaultCGFloat(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<Bool>) -> Bool {
        get { return defaultBool(for: key) ?? false }
    }
    
    public subscript (default key: ConfigKey<Bool>, namespace: String) -> Bool {
        get { return defaultBool(for: key, namespace: namespace) ?? false }
    }
    
    public subscript (default key: ConfigKey<Bool?>) -> Bool? {
        get { return defaultBool(for: key) }
    }
    
    public subscript (default key: ConfigKey<Bool?>, namespace: String) -> Bool? {
        get { return defaultBool(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<Data>) -> Data {
        get { return defaultData(for: key) ?? Data() }
    }
    
    public subscript (default key: ConfigKey<Data>, namespace: String) -> Data {
        get { return defaultData(for: key, namespace: namespace) ?? Data() }
    }
    
    public subscript (default key: ConfigKey<Data?>) -> Data? {
        get { return defaultData(for: key) }
    }
    
    public subscript (default key: ConfigKey<Data?>, namespace: String) -> Data? {
        get { return defaultData(for: key, namespace: namespace) }
    }
    
    public subscript (default key: ConfigKey<URL?>) -> URL? {
        get { return defaultString(for: key).flatMap { URL.init(string: $0) } }
    }
}
