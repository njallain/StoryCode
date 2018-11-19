//
//  Story.swift
//  StoryCodeKit
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import os.log

public protocol StoryStorage: AnyObject {
	func save(storyRestoreUrl: URL)
	var storyRestoreUrl: URL? {get}
}
public struct Story {
	public static var urlScheme = "story"
	public static var appName = "myapp"
	public struct Scene {
		public let name: String
		public let restoreValue: String
	}
	public init(storage: StoryStorage, restore: Bool = false) {
		self.storage = storage
		if restore {
			guard let url = storage.storyRestoreUrl,
			let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
			let queryItems = components.queryItems
			else {
				return
			}
			let names = components.path.split(separator: "/")
			let namesAndValues = zip(names, queryItems.compactMap{$0.value})
			for (name, value) in namesAndValues {
				self.scenes.append(Scene(name: String(name), restoreValue: value))
			}
		}
	}
	public init(restore: Bool = false) {
		self.init(storage: UserDefaults.standard, restore: restore)
	}
	let storage: StoryStorage
	public private(set) var scenes = [Scene]()
	public mutating func presenting(name: String, restoreValue: String) {
		scenes.append(Scene(name: name, restoreValue: restoreValue))
		if let url = self.restoreUrl {
			self.storage.save(storyRestoreUrl: url)
		}
	}
	private var path: String {
		return scenes.reduce("") { $0 + "/" + $1.name }
	}
	
	var restoreUrl: URL? {
		guard scenes.count > 0 else { return nil }
	  var components = URLComponents()
	  components.scheme = Story.urlScheme
	  components.host = Story.appName
	  components.path = self.path
	  components.queryItems = self.scenes.map { return URLQueryItem(name: "v", value: $0.restoreValue) }
	  return components.url
	}
}

public class NoStoryStorage: StoryStorage {
	public func save(storyRestoreUrl: URL) {
	}
	public var storyRestoreUrl: URL? {
		return nil
	}
}

fileprivate var restoreKey = "story.restore"
extension UserDefaults: StoryStorage {
	public func save(storyRestoreUrl: URL) {
		self.set(storyRestoreUrl, forKey: restoreKey)
	}
	public var storyRestoreUrl: URL? {
		return self.url(forKey: restoreKey)
	}
}


