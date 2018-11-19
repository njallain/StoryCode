//
//  StoryScene.swift
//  StoryCode
//
//  Created by Neil Allain on 11/4/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation


public protocol AnySceneDefinition {
}

public protocol SceneDefinition: AnySceneDefinition {
	init()
	associatedtype Model
	func restoreValue(_ model: Model) -> String
}

public class Scene<Definition: SceneDefinition> {
	public let definition: Definition
	public let story: Story
	public var model: Definition.Model
	var backSegue: BackSegue? = nil
	var modelChangedCallback: (Definition.Model) -> Void = {_ in return}
	public init(definition: Definition, story: Story, model: Definition.Model) {
		self.model = model
		self.definition = definition
		self.story = story
	}
	public func modelChanged() { modelChangedCallback(model) }
}

