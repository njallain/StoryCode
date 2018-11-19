//
//  SceneSegue.swift
//  StoryCodeKit
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

public struct SegueOptions: OptionSet {
	public let rawValue: Int
	public static let animated = SegueOptions(rawValue: 1 << 0)
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}


public protocol AnySceneSegue {
	var name: String {get}
}

public protocol SceneSegue: AnySceneSegue {
	associatedtype SourceScene: SceneDefinition
	associatedtype DestinationScene: SceneDefinition
	typealias RestoreFunction = (SourceScene.Model, String) -> DestinationScene.Model?
	func go<SourceController: SceneController, DestinationController: SceneController> (
		presenter: ScenePresenter,
		source: SourceController,
		destination: DestinationController,
		options: SegueOptions) -> BackSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene
	var restore: RestoreFunction? {get}
}

public protocol BackSegue {
	func back(_ options: SegueOptions)
}

