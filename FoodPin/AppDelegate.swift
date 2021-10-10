//
//  AppDelegate.swift
//  FoodPin
//
//  Created by Ray on 2021/10/5.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  enum QuickAction: String {
      case OpenFavorites = "OpenFavorites"
      case OpenDiscover = "OpenDiscover"
      case NewRestaurant = "NewRestaurant"
      
      init?(fullIdentifier: String) {
          
          guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else {
              return nil
          }
          
          self.init(rawValue: shortcutIdentifier)
      }
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // 设置返回按钮
    let backButtonImage = UIImage(named: "back")
    UINavigationBar.appearance().backIndicatorImage = backButtonImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
    
    // 自订标签列
    UITabBar.appearance().tintColor = UIColor(red: 231, green: 76, blue: 60)
    UITabBar.appearance().barTintColor = UIColor(red: 250, green: 250, blue: 250)
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
      if granted {
        print("User notifications are allowed.")
      } else {
        print("User notifications are not allowed.")
      }
    }
    
    UNUserNotificationCenter.current().delegate = self
    
    return true
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
       */
      let container = NSPersistentContainer(name: "FoodPin")
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
  func saveContext() {
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
  
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(handleQuickAction(shortcutItem: shortcutItem))
  }
  
  private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
      
      let shortcutType = shortcutItem.type
      guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) else {
          return false
      }
      
      guard let tabBarController = window?.rootViewController as? UITabBarController else {
          return false
      }
      
      switch shortcutIdentifier {
      case .OpenFavorites:
          tabBarController.selectedIndex = 0
      case .OpenDiscover:
          tabBarController.selectedIndex = 1
      case .NewRestaurant:
          if let navController = tabBarController.viewControllers?[0] {
              let restaurantTableViewController = navController.children[0]
              restaurantTableViewController.performSegue(withIdentifier: "addRestaurant", sender: restaurantTableViewController)
          } else {
              return false
          }
      }
      
      return true
  }
}

// MARK: - User Notifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "foodpin.makeReservation" {
            print("Make reservation...")
            if let phone = response.notification.request.content.userInfo["phone"] {
                let telURL = "tel://\(phone)"
                if let url = URL(string: telURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        print("calling \(telURL)")
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        
        completionHandler()
    }
}
