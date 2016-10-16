//
//  Shrimp.swift
//  RemoteConfigPlayground
//
//  Created by Suguru Kishimoto on 10/14/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

public class Shrimp {
    public enum Result {
        case success(RemoteConfig)
        case failure(Error?)
    }
    
    public static let shared = Shrimp()
    public private(set) lazy var config: RemoteConfig = RemoteConfig()
    public var developerMode = false { didSet { updateConfig() } }
    public var defaultExpirationDuration: TimeInterval = 60 * 60 * 12
    
    public var isDeveloperMode: Bool {
        return FIRRemoteConfig.remoteConfig().configSettings.isDeveloperModeEnabled
    }
    
    private var defaults: [String: [String: NSObject]] = [:]
    
    private init() {
        updateConfig()
    }
    
    public func fetch(withExpirationDuration expirationDuration: TimeInterval? = nil, completion: @escaping (Result) -> Void) {
        let expire = expirationDuration ?? defaultExpirationDuration
        FIRRemoteConfig.remoteConfig().fetch(withExpirationDuration: expire) { [unowned self] status, error in
            if status == .success {
                FIRRemoteConfig.remoteConfig().activateFetched()
                completion(.success(self.config))
            } else {
                completion(.failure(error))
            }
        }
    }
    
    private func updateConfig() {
        if let settings = FIRRemoteConfigSettings(developerModeEnabled: self.developerMode) {
            FIRRemoteConfig.remoteConfig().configSettings = settings
        }
    }
}
