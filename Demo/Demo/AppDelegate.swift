//
//  AppDelegate.swift
//  Demo
//
//  Created by Suguru Kishimoto on 10/15/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        FIRApp.configure()
        return true
    }
}

