//
//  ModalSegue.swift
//  StoryCode
//
//  Created by Neil Allain on 11/17/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

class ModalBackSegue : AnyActiveSegue {
	weak var presenter: ScenePresenter?
	init(presenter: ScenePresenter) {
		self.presenter = presenter
	}
	func back(_ options: SegueOptions) {
		presenter?.dismissModalScene(options: options)
	}
}


public struct ModalSegue<SourceScene: SceneDefinition, DestinationScene: SceneDefinition>: SceneSegue {
	public init() {}
	public func go<SourceController: SceneController, DestinationController: SceneController> (
		presenter: ScenePresenter,
		source: SourceController,
		destination: DestinationController,
		options: SegueOptions) -> AnyActiveSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene {
			presenter.showModalScene(controller: destination, options: options)
			return ModalBackSegue(presenter: presenter)
	}
	
}
