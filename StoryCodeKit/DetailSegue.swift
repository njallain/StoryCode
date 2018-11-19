//
//  DetailSegue.swift
//  StoryCode
//
//  Created by Neil Allain on 11/17/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

class DetailBackSegue : BackSegue {
	weak var presenter: ScenePresenter?
	let previousStory: Story
	init(presenter: ScenePresenter, previousStory: Story) {
		self.presenter = presenter
		self.previousStory = previousStory
	}
	deinit {
		previousStory.presenting()
	}
	func back(_ options: SegueOptions) {
	}
}
public struct DetailSegue<SourceScene: SceneDefinition, DestinationScene: SceneDefinition>: SceneSegue {
	public private(set) var name: String
	public private(set) var restore: RestoreFunction?
	public init(_ name: String, restore: RestoreFunction? = nil) {
		self.name = name
		self.restore = restore
	}
	public func go<SourceController: SceneController, DestinationController: SceneController> (
		presenter: ScenePresenter,
		source: SourceController,
		destination: DestinationController,
		options: SegueOptions) -> BackSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene {
			presenter.showDetailScene(controller: destination, options: options)
			return DetailBackSegue(presenter: presenter, previousStory: source.scene.story)
			
	}
}

