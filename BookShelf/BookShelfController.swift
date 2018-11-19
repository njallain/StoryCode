//
//  BookShelfController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/10/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import UIKit
import StoryCodeKit

struct BookShelfScene: SceneDefinition {
	typealias Model = BookShelf
	func restoreValue(_ model: BookShelf) -> String { return "" }
	let viewBook = DetailSegue<BookShelfScene, BookScene>("viewBook", restore: BookShelf.restoreBook)
}


class BookShelfController: UITableViewController, SceneController, ScenePresenter {
	let segues = BookShelfScene()
	var scene: Scene<BookShelfScene>!
	var scenePresenter: ScenePresenter { return self }
	
	func setup(scene: Scene<BookShelfScene>) {
		self.scene = scene
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Bookshelf"
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: Book.self))
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return scene.model.books.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Book.self), for: indexPath)
		let book = scene.model.books[indexPath.row]
		cell.textLabel?.text = book.title
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let bookController = BookController()
		self.go(segues.viewBook, controller: bookController, model: scene.model.books[indexPath.row]) { [weak self] book in
			guard let self = self else { return }
			self.scene.model.books[indexPath.row] = book
			self.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
	
	func restore(scene: Story.Scene) -> AnySceneController? {
		if scene.name == segues.viewBook.name {
			
			guard let book = segues.viewBook.restore?(self.scene.model, scene.restoreValue) else { return nil }
			let bookController = BookController()
			self.go(segues.viewBook, controller: bookController, model: book, presenter: self.scenePresenter, options: []) { [weak self] book in
				guard let self = self else { return }
				guard let bookIndex = self.scene.model.books.firstIndex(where: { $0.id == book.id }) else { return }
				self.scene.model.books[bookIndex] = book
				self.tableView.reloadRows(at: [IndexPath(row: bookIndex, section: 0)], with: .automatic)
			}
			return bookController
		}
		
		return nil
	}
}
