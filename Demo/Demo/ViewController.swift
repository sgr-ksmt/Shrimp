//
//  ViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 10/15/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

enum SampleType: Int, CustomStringConvertible {
    case a, b, none
    
    var description: String {
        switch self {
        case .a:
            return "(Type A)"
        case .b:
            return "(Type B)"
        case .none:
            return ""
        }
    }
}

enum NotificationKey: String {
    case helloworld = "notif_1"
    case lgtm = "notif_2"
    
    var title: String {
        return "Sample"
    }
    
    var message: String {
        switch self {
        case .helloworld:
            return "Hello world!!"
        case .lgtm:
            return "Looks good to me!!"
        }
    }
}

extension ConfigKeys {
    static let quantity = ConfigKey<Int>("quantity")
    static let price = ConfigKey<Float>("price")
    static let item = ConfigKey<String>("item")
    static let testType = ConfigKey<SampleType>("test_type")
    static let notificationKey = ConfigKey<NotificationKey?>("notification_key")
    static let backgroundColor = ConfigKey<UIColor?>("bg_color")
    static let url = ConfigKey<URL?>("url")
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
    
    subscript (key: ConfigKey<NotificationKey?>) -> NotificationKey? {
        get {
            return string(for: key).flatMap(NotificationKey.init)
        }
        set {
            set(key: key, value: newValue?.rawValue)
        }
    }

    subscript (default key: ConfigKey<NotificationKey?>) -> NotificationKey? {
        get {
            return defaultString(for: key).flatMap(NotificationKey.init)
        }
    }

    subscript (key: ConfigKey<UIColor?>) -> UIColor? {
        get {
            return string(for: key).flatMap { UIColor.init($0) }
        }
        set {
            set(key: key, value: newValue?.hexString())
        }
    }
    
    subscript (default key: ConfigKey<UIColor?>) -> UIColor? {
        get {
            return defaultString(for: key).flatMap { UIColor.init($0) }
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.black.cgColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Shrimp.shared.developerMode = true
        Shrimp.shared.defaultExpirationDuration = 60 * 10
        
        // set default values.
        Shrimp.shared.config[.quantity] = 0
        Shrimp.shared.config[.item] = "Apple"
        Shrimp.shared.config[.testType] = .none
        Shrimp.shared.config[.backgroundColor] = UIColor.white
        
        self.view.backgroundColor = Shrimp.shared.config[.backgroundColor]
        self.label.text = " "
        fetch()
    }
    
    private func fetch() {
        // fetch with expire (1 min)
        Shrimp.shared.fetch(withExpirationDuration: 60.0 * 5.0) { [weak self] result in
            switch result {
            case .success(let config):
                print("[!!!] quantity:", config[.quantity]) // as int
                print("[!!!] default quantity:", config[default: .quantity]) // as int
                print("[!!!] price:", config[.price]) // as Float
                print("[!!!] default price:", config[default: .price]) // as Float
                print("[!!!] item:", config[.item]) // as String
                print("[!!!] default item:", config[default: .item]) // as String
                print("[!!!] test_type:", config[.testType]) // as enum(Int)
                print("[!!!] notification_key:", config[.notificationKey]) // as enum(String)
                print("[!!!] default notification_key:", config[default: .notificationKey]) // as enum(String)
                print("[!!!] bg_color:", config[.backgroundColor]) // as UIColor
                print("[!!!] default bg_color:", config[default: .backgroundColor]) // as UIColor
                print("[!!!] url:", config[.url]) // as URL
                print("[!!!] default url:", config[default: .url]) // as URL?
                
                self?.updateView(with: config)
                self?.showAlert(with: config)
            case .failure(let error):
                print(error)
                // update using stored value
                let currentConfig = Shrimp.shared.config
                self?.updateView(with: currentConfig)
                self?.showAlert(with: currentConfig)
            }
        }
    }
    
    private func updateView(with config: RemoteConfig) {
        view.backgroundColor = config[.backgroundColor]
        let item = config[.item]
        let price = config[.price]
        let quantity = config[.quantity]
        let type = config[.testType].description
        label.text = "\(item)\(type) : ($\(price), \(quantity))"
    }
    
    private func showAlert(with config: RemoteConfig) {
        if let notification = config[.notificationKey] {
            let alert = UIAlertController(title: notification.title, message: notification.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fetchButtonDidTap(_: UIButton!) {
        fetch()
    }
    
    @IBAction func openURLButtonDidTap(_: UIButton!) {
        if let url = Shrimp.shared.config[.url] {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
