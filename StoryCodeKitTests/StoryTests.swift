//
//  StoryTests.swift
//  StoryCodeKitTests
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import XCTest
@testable import StoryCodeKit

class StoryTests: XCTestCase {
	func testRestoreUrl() {
		var story = Story()
		story.presenting(name: "campaign", restoreValue: "a b")
		story.presenting(name: "npc", restoreValue: "c&d")
		assertEqual("story://\(Story.appName)/campaign/npc?v=a%20b&v=c%26d", story.restoreUrl?.absoluteString)
	}
	
	func testStoreAndRestore() {
		let storage = TestStorage()
		let story = Story(storage: storage)
		var another = story
		another.presenting(name: "npc", restoreValue: "value")
		assertTrue(another.storage === story.storage)
		assertEqual(another.restoreUrl, storage.value)
		
		let restoredStory = Story(storage: storage, restore: true)
		assertEqual(storage.value, restoredStory.restoreUrl)
		//assertEqual(another.restoreValue, storage.storyRestoreValue)
	}
}


class TestStorage: StoryStorage {
	var value: URL?
	public func save(storyRestoreUrl: URL) {
		value = storyRestoreUrl
	}
	public var storyRestoreUrl: URL? {
		return value
	}

}
