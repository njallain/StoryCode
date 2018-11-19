//
//  NavigationSegue.swift
//  StoryCode
//
//  Created by Neil Allain on 11/17/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

class NavigationBackSegue : AnyActiveSegue {
	weak var presenter: ScenePresenter?
	init(presenter: ScenePresenter) {
		self.presenter = presenter
	}
	func back(_ options: SegueOptions) {
		presenter?.popScene(options: options)
	}
}
public struct NavigationSegue<SourceScene: SceneDefinition, DestinationScene: SceneDefinition>: SceneSegue {
	public private(set) var name: String
	public init(_ name: String) { self.name = name }
	public func go<SourceController: SceneController, DestinationController: SceneController> (
		presenter: ScenePresenter,
		source: SourceController,
		destination: DestinationController,
		options: SegueOptions) -> AnyActiveSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene {
			presenter.pushScene(controller: destination, options: options)
			return NavigationBackSegue(presenter: presenter)
			
	}
}

