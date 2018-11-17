//
//  BookShelfController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/10/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import UIKit

struct BookShelfScene: SceneDefinition {
    var name: String { return "bookshelf" }
    typealias Model = BookShelf
	
    let viewBook = NavigationSegue<BookShelfScene, BookScene>()
}


class BookShelfController: UITableViewController, SceneController, ScenePresenter {
    var scene: Scene<BookShelfScene>!
    var scenePresenter: ScenePresenter { return self }
	
    func setup(scene: Scene<BookShelfScene>) {
        self.scene = scene
    }
    @objc func navigateBack() {
        self.popScene(options: [.animated])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navigateBack))
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
        self.go(\.viewBook, controller: bookController, model: scene.model.books[indexPath.row]) { [weak self] book in
            guard let self = self else { return }
            self.scene.model.books[indexPath.row] = book
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
	
}
