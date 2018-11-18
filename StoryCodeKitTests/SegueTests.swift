//
//  StoryCodeKitTests.swift
//  StoryCodeKitTests
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import XCTest
@testable import StoryCodeKit


class SegueTests: XCTestCase {
	
	func testDetailSegue() {
		let root = RootController()
		let story = Story()
		let campaigns = sampleCampaigns()
		let campaignController = CampaignController()
		root.setup(scene: Scene(definition: RootScene(), story: story, model: campaigns))
		var modelUpdated = false
		root.go(\.viewCampaign, controller: campaignController, model: campaigns[0]) {
			modelUpdated = true
			root.scene.model[0] = $0
		}
		assertNotNil(root.detailController)
		assertTrue(root.detailController === campaignController)
		assertFalse(modelUpdated)
		assertNotNil(campaignController.scene)
		assertEqual(campaignController.scene.model.id, campaigns[0].id)
		campaignController.scene.modelChanged()
		assertTrue(modelUpdated)
		//let rootScene = RootScene(
	}
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
}


