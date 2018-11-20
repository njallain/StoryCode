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
	public static let popover = SegueOptions(rawValue: 1 << 1)
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}

public protocol SeguePopover {
	func setup(source: AnySceneController, destination: AnySceneController)
}
public struct SegueStyle {
	public static let animated = SegueStyle([.animated])
	public static let restore = SegueStyle([])
	
	public init(_ options: SegueOptions) {
		self.options = options
		popover = nil
	}
	public init(_ options: SegueOptions, popover: SeguePopover) {
		self.options = options.union(.popover)
		self.popover = popover
	}
	public let options: SegueOptions
	var popover: SeguePopover?
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
		style: SegueStyle) -> BackSegue
		where SourceController.SceneType == SourceScene, DestinationController.SceneType == DestinationScene
	var restore: RestoreFunction? {get}
}

public protocol BackSegue {
	func back(_ style: SegueStyle)
}

