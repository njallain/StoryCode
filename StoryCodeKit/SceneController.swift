//
//  SceneController.swift
//  StoryCodeKit
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

public protocol AnySceneController: AnyObject {
	/**
	Restore the scene presented from this scene if possible
	*/
	func restore(scene: Story.Scene) -> AnySceneController?
}

public protocol SceneController: AnySceneController {
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

public extension AnySceneController {
	func restore(scene: Story.Scene) -> AnySceneController? {
		return nil
	}
	@discardableResult
	func restoreAll(scenes: [Story.Scene]) -> AnySceneController? {
		guard
			let scene = scenes.first,
			let subController = self.restore(scene: scene)
		else { return self }
		let remainingScenes = Array(scenes.dropFirst())
		return subController.restoreAll(scenes: remainingScenes)
	}
}

public extension SceneController {
	func go<DestinationController: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		controller: DestinationController,
		model: DestinationController.SceneType.Model,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void)
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
			let presenter = self.scenePresenter
			self.go(segue, controller: controller, model: model, presenter: presenter, options: [.animated], modelChanged: modelChanged)
	}
	
	func go<DestinationController: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		controller: DestinationController,
		model: DestinationController.SceneType.Model,
		presenter: ScenePresenter,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void)
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
			self.go(segue, controller: controller, model: model, presenter: presenter, options: [.animated], modelChanged: modelChanged)
	}
	
	func restore<DestinationController: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		controller: DestinationController,
		parentModel: SegueType.SourceScene.Model,
		restoreValue: String,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void) -> DestinationController?
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
			let presenter = self.scenePresenter
			return self.restore(segue,
				controller: controller,
				parentModel: parentModel,
				restoreValue: restoreValue,
				presenter: presenter,
				modelChanged: modelChanged)
	}
	
	func restore<DestinationController: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		controller: DestinationController,
		parentModel: SegueType.SourceScene.Model,
		restoreValue: String,
		presenter: ScenePresenter,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void) -> DestinationController?
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
		guard let model = segue.restore?(parentModel, restoreValue) else { return nil }
		self.go(segue, controller: controller, model: model, presenter: presenter, options: [], modelChanged: modelChanged)
		return controller
	}
	
	func go<DestinationController: SceneController, SegueType: SceneSegue>(
		_ segue: SegueType,
		controller: DestinationController,
		model: DestinationController.SceneType.Model,
		presenter: ScenePresenter,
		options: SegueOptions,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void)
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
			let sceneDef = DestinationController.SceneType()
			let restoreValue = sceneDef.restoreValue(model)
			var story = self.scene.story
			story.presenting(name: segue.name, restoreValue: restoreValue)
			let destScene = Scene(definition: sceneDef, story: story, model: model)
			destScene.modelChangedCallback = modelChanged
			controller.setup(scene: destScene)
			destScene.backSegue = segue.go(presenter: presenter, source: self, destination: controller, options: options)
			
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

