//
//  AppDelegate.swift
//  NFCDemo
//
//  Created by Michael Redoble on 06/04/2018.
//  Copyright © 2018 Michael Redoble. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.17m.Fetch", using: nil) { (task) in
                self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
            }
        }
        else {
            print("NOT AVAILABLE!!!")
        }
        
        return true
    }

    @available(iOS 13.0, *)
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
          PokeManager.urlSession.invalidateAndCancel()
        }
        
        let randomPoke = (1...151).randomElement() ?? 1
        
        PokeManager.pokemon(id: randomPoke) { (pokemon) in
          NotificationCenter.default.post(name: .newPokemonFetched,
                                          object: self,
                                          userInfo: ["pokemon": pokemon])
          task.setTaskCompleted(success: true)
        }
        
        scheduleBackgroundPokemonFetch()
    }
    
    @available(iOS 13.0, *)
    func scheduleBackgroundPokemonFetch() {
        let pokemonFetchTask = BGAppRefreshTaskRequest(identifier: "com.17m.Fetch")
        pokemonFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        
        do {
          try BGTaskScheduler.shared.submit(pokemonFetchTask)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
            scheduleBackgroundPokemonFetch()
        } else {
            print("NOT AVAILABLE!!!")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension Notification.Name {
  static let newPokemonFetched = Notification.Name("com.newPokemonFetched")
}
