//
//  AppDelegate.swift
//  AirToDo
//
//  Created by yoshiki-t on 2018/05/12.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import CoreData
import SlideMenuControllerSwift
import UserNotifications
import NotificationCenter
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    var reminderManager = ReminderManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Google Sign-in
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "752419583646-pfbeb5skfj6h84tkmakdnq6berefieqt.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            print("signIn")
            GIDSignIn.sharedInstance().signInSilently()
            
            // Set initialView
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ContainerViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        } else {
            print("cant signIn")
            
            // Set initialView
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        // Notification / Reminder Setting
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests();
        let center = UNUserNotificationCenter.current()
        
        // request to notify for user
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Allowed")
            } else {
                print("Didn't allowed")
            }
        }
        
        center.delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Delete old Notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests();
        
        let remindList = reminderManager.readData(minimumRemind: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.dateFormat = "MMM. d"
        
        for reminder in remindList {
            
            guard let taskName = reminder.task?.taskName else {
                abort()
            }
            
            guard let dueDate = reminder.task?.dueDate else {
                abort()
            }
            
            print(dateFormatter.string(from: dueDate))
            
            let body: String = "DueDate: " + dateFormatter.string(from: dueDate)
            
            NotificationManager.setLocalNotification(identifier: reminder.remID, date: reminder.remDate, title: taskName, body: body)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // for Google Sign-in
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Airlydo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// Google Sign-in
extension AppDelegate : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print(user.profile.email)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}


// Local Notification
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
}



