//
//  Story.swift
//  StoryCodeKit
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

public struct Story {
	private struct Scene {
		let name: String
		let restoreValue: String
	}
	public init() {}
	private var scenes = [Scene]()
	public mutating func presenting(name: String, restoreValue: String) {
		scenes.append(Scene(name: name, restoreValue: restoreValue))
	}
	var path: String {
		return scenes.reduce("") { $0 + "/" + $1.name }
		
	}
}
