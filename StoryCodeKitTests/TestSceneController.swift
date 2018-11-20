//
//  TestSceneController.swift
//  StoryCodeKitTests
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import StoryCodeKit

class TestSceneController<SceneType: SceneDefinition>: SceneController, ScenePresenter {
	let segues = SceneType()
	var scene: Scene<SceneType>!
	var pushedController: AnyObject?
	var modalController: AnyObject?
	var detailController: AnyObject?
	
	required init() {}
	
	func setup(scene: Scene<SceneType>) {
		self.scene = scene
	}
	
	var scenePresenter: ScenePresenter { return self }
	
	func pushScene<Controller>(controller: Controller, style: SegueStyle) where Controller : SceneController {
		pushedController = controller
	}
	
	func popScene(style: SegueStyle) {
		pushedController = nil
	}
	
	func showModalScene<Controller>(controller: Controller, style: SegueStyle) where Controller : SceneController {
		modalController = controller
	}
	
	func dismissModalScene(style: SegueStyle) {
		modalController = nil
	}
	
	func showDetailScene<Controller>(controller: Controller, style: SegueStyle) where Controller : SceneController {
		detailController = controller
	}
}


