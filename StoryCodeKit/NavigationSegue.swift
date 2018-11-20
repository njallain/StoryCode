//
//  NavigationSegue.swift
//  StoryCode
//
//  Created by Neil Allain on 11/17/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

class NavigationBackSegue : BackSegue {
	weak var presenter: ScenePresenter?
	let previousStory: Story
	init(presenter: ScenePresenter, previousStory: Story) {
		self.presenter = presenter
		self.previousStory = previousStory
	}
	func back(_ style: SegueStyle) {
		presenter?.popScene(style: style)
	}
	deinit {
		previousStory.presenting()
	}
}
public struct NavigationSegue<SourceScene: SceneDefinition, DestinationScene: SceneDefinition>: SceneSegue {
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
		style: SegueStyle) -> BackSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene {
			presenter.pushScene(controller: destination, style: style)
			return NavigationBackSegue(presenter: presenter, previousStory: source.scene.story)
			
	}
}

