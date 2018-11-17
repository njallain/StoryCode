//
//  SampleStory.swift
//  StoryCode
//
//  Created by Neil Allain on 11/5/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

public struct BookShelf {
	public var books: [Book]
}

private var nextBookId = 1

public struct Book {
	public static let none = Book()
	public var id: Int
	public var title: String
	var description: String
	
	public init(title: String) {
		self.title = title
		self.id = nextBookId
		nextBookId += 1
		self.description = ""
	}
	private init() {
		self.id = 0
		self.title = ""
		self.description = ""
	}
}


public struct EditText {
	public var text: String
}
