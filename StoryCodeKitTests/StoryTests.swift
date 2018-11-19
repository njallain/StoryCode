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
	func testPath() {
		let story = Story()
		assertEqual("", story.path)
		var next = story
		next.presenting(name: "campaign", restoreValue: "")
		assertEqual("/campaign", next.path)
		next.presenting(name: "npc", restoreValue: "")
		assertEqual("/campaign/npc", next.path)
		assertEqual("", story.path)
	}

}
