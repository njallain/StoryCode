//
//  SceneController.swift
//  StoryCodeKit
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

public protocol SceneController: AnyObject {
	associatedtype SceneType: SceneDefinition
	init()
	var scene: Scene<SceneType>! {get}
	func setup(scene: Scene<SceneType>)
	var scenePresenter: ScenePresenter {get}
}

/**
Handles the platform specific scene presentation.
*/
public protocol ScenePresenter: AnyObject {
	func pushScene<Controller: SceneController>(controller: Controller, options: SegueOptions)
	func popScene(options: SegueOptions)
	func showModalScene<Controller: SceneController>(controller: Controller, options: SegueOptions)
	func dismissModalScene(options: SegueOptions)
	func showDetailScene<Controller: SceneController>(controller: Controller, options: SegueOptions)
}

public extension SceneController {
//	func go<DestinationController: SceneController, SegueType: SceneSegue>(
//		_ path: KeyPath<SceneType, SegueType>,
//		controller: DestinationController,
//		model: DestinationController.SceneType.Model,
//		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void)
//		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
//			let segue = self.scene.definition[keyPath: path]
//			let sceneDef = DestinationController.SceneType()
//			let destScene = Scene(definition: sceneDef, story: self.scene.story, model: model)
//			destScene.modelChangedCallback = modelChanged
//			controller.setup(scene: destScene)
//			destScene.backSegue = segue.go(presenter: self.scenePresenter, source: self, destination: controller, options: [.animated])
//	}
//	
	func go<DestinationController: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		controller: DestinationController,
		model: DestinationController.SceneType.Model,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void)
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
			let sceneDef = DestinationController.SceneType()
			let restoreValue = sceneDef.restoreValue(model)
			var story = self.scene.story
			story.presenting(name: segue.name, restoreValue: restoreValue)
			let destScene = Scene(definition: sceneDef, story: self.scene.story, model: model)
			destScene.modelChangedCallback = modelChanged
			controller.setup(scene: destScene)
			destScene.backSegue = segue.go(presenter: self.scenePresenter, source: self, destination: controller, options: [.animated])
			
	}
	
	func finish(_ viewModel: SceneType.Model) {
		scene.model = viewModel
		scene.modelChanged()
		guard let backSegue = self.scene.backSegue else {
			return
		}
		backSegue.back([.animated])
	}
}

