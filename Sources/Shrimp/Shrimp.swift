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
        case failure(NSError?)
    }
    
    public static let shared = Shrimp()
    public private(set) lazy var config: RemoteConfig = RemoteConfig()
    public var developerMode = false { didSet { updateConfig() } }
    public var defaultExpirationDuration: NSTimeInterval = 60 * 60 * 12
    
    public var isDeveloperMode: Bool {
        return FIRRemoteConfig.remoteConfig().configSettings.isDeveloperModeEnabled
    }
    
    private var defaults: [String: [String: NSObject]] = [:]
    
    private init() {
        updateConfig()
    }
    
    public func fetch(withExpirationDuration expirationDuration: NSTimeInterval? = nil, completion: (Result) -> Void) {
        let expire = expirationDuration ?? defaultExpirationDuration
        FIRRemoteConfig.remoteConfig().fetchWithExpirationDuration(expire) { [unowned self] status, error in
            if status == .Success {
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
