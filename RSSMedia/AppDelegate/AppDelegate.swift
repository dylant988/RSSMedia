//
//  AppDelegate.swift
//  RSSMedia
//
//  Created by Tan Zilong on 5/22/19.
//  Copyright © 2019 DyCom. All rights reserved.
//

import UIKit
import CoreData
import NotificationBannerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RSSMedia")
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
    
    // MARK: Fetch one feed according to the id
    func fetchOneFeed(feedId: String) -> RSSFeed? {
        var rssFeeds : RSSFeed?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchRequest.predicate = NSPredicate(format: "id == %@", feedId)
        do {
            let feeds = try persistentContainer.viewContext.fetch(fetchRequest) as! [Feed]
            for feed in feeds {
                guard let id = feed.id,
                    let title = feed.title,
                    let desc = feed.desc,
                    let date = feed.pubDate,
                    let link = feed.link
                    else { return rssFeeds }
                rssFeeds = RSSFeed(id: id, title: title, desc: desc, pubDate: date, link: link, isSaved: false)
            }
        } catch {
            NotificationBanner(subtitle: error.localizedDescription, style: .warning).show()
        }
        return rssFeeds
    }
    
    // MARK: Add the selected feed to Core Data
    func saveCurrentFeed(rssFeed: RSSFeed) {
        let bgContext = persistentContainer.newBackgroundContext()
        let feed = Feed(context: bgContext)
        feed.id = rssFeed.id
        feed.title = rssFeed.title
        feed.desc = rssFeed.desc
        feed.pubDate = rssFeed.pubDate
        feed.link = rssFeed.pubDate
        do {
            try bgContext.save()
            
        } catch {
            NotificationBanner(subtitle: error.localizedDescription, style: .warning).show()
        }
    }
    
    // MARK: Fetch all feeds in Core Data
    func fetchSavedFeed() -> [RSSFeed]? {
        var rssFeeds = [RSSFeed]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        do {
            let feeds = try persistentContainer.viewContext.fetch(fetchRequest) as! [Feed]
            for feed in feeds {
                guard let id = feed.id,
                      let title = feed.title,
                      let desc = feed.desc,
                      let date = feed.pubDate,
                      let link = feed.link
                    else { return rssFeeds }
                rssFeeds.append(RSSFeed(id: id, title: title, desc: desc, pubDate: date, link: link, isSaved: true))
            }
        } catch {
            NotificationBanner(subtitle: error.localizedDescription, style: .warning).show()
        }
        return rssFeeds
    }
    
    // MARK: Remove selected feed according to the id
    func deleteSelectedFeed(feedId: String) {
        let bgContext = persistentContainer.newBackgroundContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchRequest.predicate = NSPredicate(format: "id == %@", feedId)
        do {
            let record = try bgContext.fetch(fetchRequest) as! [Feed]
            bgContext.delete(record.first!)
            try bgContext.save()
        } catch {
            NotificationBanner(subtitle: error.localizedDescription, style: .warning).show()
        }
    }

}

// Mark: Provide appDelegate instance to manipulate data
let appDelegate = UIApplication.shared.delegate as! AppDelegate
