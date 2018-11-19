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
		verifySegue(root.segues.viewCampaign, source: root, destination: campaignController, model: campaigns[0])
		assertNotNil(root.detailController)
		assertTrue(root.detailController === campaignController)
		assertEqual(campaignController.scene.model.id, campaigns[0].id)
	}
	func testNavigateSegue() {
		let campaign = campaigns[0]
		let npc = campaign.npcs[0]
		campaignController.setup(scene: Scene(definition: CampaignScene(), story: story, model: campaign))
		verifySegue(campaignController.segues.viewNpc, source: campaignController, destination: npcController, model: npc)
		assertNotNil(campaignController.pushedController)
		assertTrue(campaignController.pushedController === npcController)
		assertEqual(npcController.scene.model.id, campaign.npcs[0].id)
	}

	func testModalSegue() {
		let campaign = campaigns[0]
		campaignController.setup(scene: Scene(definition: CampaignScene(), story: story, model: campaign))
		verifySegue(campaignController.segues.editName, source: campaignController, destination: textController, model: campaign.name)
		assertNotNil(campaignController.modalController)
		assertTrue(campaignController.modalController === textController)
		assertEqual(textController.scene.model, campaign.name)
	}

	private func verifySegue<Source: SceneController, Destination: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		source: Source,
		destination: Destination,
		model: SegueType.DestinationScene.Model
	) where Source.SceneType == SegueType.SourceScene, Destination.SceneType == SegueType.DestinationScene {
		var modelUpdated = false
		source.go(segue, controller: destination, model: model) { _ in
			modelUpdated = true
		}
		assertFalse(modelUpdated)
		assertNotNil(destination.scene)
		destination.scene.modelChanged()
		assertTrue(modelUpdated)
	}
	override func setUp() {
		root = RootController()
		story = Story()
		campaigns = sampleCampaigns()
		campaignController = CampaignController()
		textController = TextController()
		root.setup(scene: Scene(definition: RootScene(), story: story, model: campaigns))
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	private var root =  RootController()
	private var story = Story()
	private var campaigns: [Campaign] = []
	private var campaignController = CampaignController()
	private var npcController = NpcController()
	private var textController = TextController()
}


