//
//  AppDelegate.swift
//  Todoey
//
//  Created by Kyaw Kyaw on 3/28/19.
//  Copyright © 2019 Kyaw Kyaw Thar. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
  class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
   //  print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
     
        do{
            _ = try Realm()

        }catch {
            print("Error initialing new realm \(error)")
        }
        
        return true
    }
    

}

