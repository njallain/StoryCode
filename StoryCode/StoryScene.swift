//
//  StoryScene.swift
//  StoryCode
//
//  Created by Neil Allain on 11/4/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation


public protocol AnySceneDefinition {
	var name: String {get}
	
}

public protocol SceneDefinition: AnySceneDefinition {
	init()
	associatedtype Model
}

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

public class Scene<Definition: SceneDefinition> {
	let definition: Definition
	let story: Story
	var model: Definition.Model
	var backSegue: AnyActiveSegue? = nil
	var modelChangedCallback: (Definition.Model) -> Void = {_ in return}
	public init(definition: Definition, story: Story, model: Definition.Model) {
		self.model = model
		self.definition = definition
		self.story = story
	}
	func modelChanged() { modelChangedCallback(model) }
}

extension SceneController {
	func go<DestinationController: SceneController, SegueType: SceneSegue>(
		_ path: KeyPath<SceneType, SegueType>,
		controller: DestinationController,
		model: DestinationController.SceneType.Model,
		modelChanged: @escaping (DestinationController.SceneType.Model) -> Void)
		where SegueType.SourceScene == SceneType, SegueType.DestinationScene == DestinationController.SceneType {
			let segue = self.scene.definition[keyPath: path]
			let sceneDef = DestinationController.SceneType()
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

public struct SegueOptions: OptionSet {
	public let rawValue: Int
	static let animated = SegueOptions(rawValue: 1 << 0)
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}


public protocol SceneSegue {
	associatedtype SourceScene: SceneDefinition
	associatedtype DestinationScene: SceneDefinition
	func go<SourceController: SceneController, DestinationController: SceneController> (
		presenter: ScenePresenter,
		source: SourceController,
		destination: DestinationController,
		options: SegueOptions) -> AnyActiveSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene
	
}

public protocol AnyActiveSegue {
	func back(_ options: SegueOptions)
}

public struct Story {
	private var scenes = [AnySceneDefinition]()
	
}
