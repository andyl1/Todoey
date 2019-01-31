//
//  AppDelegate.swift
//  Todoey
//
//  Created by Andy Lee on 20/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialise new Realm object
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }
}
