//
//  AppDelegate.swift
//  StoryCode
//
//  Created by Neil Allain on 11/4/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import UIKit
import StoryCodeKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let bookshelf = BookShelf(books: [
			Book(title: "The Lion, the Witch and the Wardrobe"),
			Book(title: "The Dragonbone Chair"),
			Book(title: "Star Wars: A New Hope")
			])
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.backgroundColor = .white
		let bookshelfController = BookShelfController()
		Story.appName = "bookshelf"
		let scene = Scene(definition: BookShelfScene(), story: Story(), model: bookshelf)
		bookshelfController.setup(scene: scene)
		let nav = UINavigationController(rootViewController: bookshelfController)
//		let detailScene = Scene(definition: BookScene(), story: story, model: .none)
//		let bookController = BookController()
//		bookController.setup(scene: detailScene)
		let splitView = UISplitViewController()
		splitView.viewControllers = [nav, UINavigationController(rootViewController: UIViewController())]
		splitView.preferredDisplayMode = .allVisible
		splitView.delegate = self
		nav.delegate = self
		window.rootViewController = splitView
		
		let restoredStory = Story(restore: true)
		bookshelfController.restoreAll(scenes: restoredStory.scenes)
		window.makeKeyAndVisible()
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
	}
	

}


extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(
		_ splitViewController: UISplitViewController,
		collapseSecondary secondaryViewController: UIViewController,
		onto primaryViewController: UIViewController) -> Bool {
		// Return true to prevent UIKit from applying its default behavior
		return true
	}
}

extension AppDelegate: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		print("will show: \(String(describing: viewController))")
		for vc in navigationController.children {
			print("child: \(String(describing: vc))")
		}
	}
}
