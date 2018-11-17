//
//  BookController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/10/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import UIKit

struct BookScene: SceneDefinition {
    var name: String { return "book" }
    typealias Model = Book
	
    let editTitle = ModalSegue<BookScene, EditTextScene>()
    let editDescription = ModalSegue<BookScene, EditTextScene>()
}
class BookController: UIViewController, SceneController, ScenePresenter {
	
    var scene: Scene<BookScene>!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var editTitleButton: UIButton!
    var editDescriptionButton: UIButton!
	
    func setup(scene: Scene<BookScene>) {
        self.scene = scene
    }

    private func setupView() {
            //self.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.backgroundColor = .white
            titleLabel = UILabel()
            descriptionLabel = UILabel()
            editTitleButton = UIButton(type:.roundedRect)
            editDescriptionButton = UIButton(type:.roundedRect)
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 3
            titleLabel.textAlignment = .center
            descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .natural
			
            editTitleButton.setTitle("Edit Title", for: .normal)
            editDescriptionButton.setTitle("Edit Description", for: .normal)
            updateViewModel()
            let stackView = UIStackView(arrangedSubviews: [titleLabel, editTitleButton, descriptionLabel, editDescriptionButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = 10.0
            self.view.addSubview(stackView)
            let padding = CGFloat(25.0)
        //let safeLayout = view.safeAreaLayoutGuide
        let safeLayout = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: padding),
                stackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
                stackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -padding),
                stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
                stackView.bottomAnchor.constraint(lessThanOrEqualTo: safeLayout.bottomAnchor),
                //stackView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -padding),
            ])
            updateViewModel()
    }

    private func updateViewModel() {
        self.titleLabel.text = scene.model.title
        self.descriptionLabel.text = scene.model.description
        self.editTitleButton.addTarget(self, action: #selector(editTitle), for: .touchUpInside)
        self.editDescriptionButton.addTarget(self, action: #selector(editDescription), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navigateBack))
        self.setupView()
    }
    @objc func navigateBack() {
        self.popScene(options: [.animated])
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.subviews[0].setNeedsLayout()
        //self.view.setNeedsLayout()
    }
    @objc func editTitle(_ sender: UIButton) {
        let controller = EditTextController()
        let model = EditText(text: scene.model.title)
        self.go(\.editTitle, controller: controller, model: model) { [weak self] textModel in
            guard let self = self else {return}
            self.scene.model.title = textModel.text
            self.titleLabel.text = textModel.text
            self.view.setNeedsLayout()
            self.scene.modelChanged()
        }
    }
    @objc func editDescription(_ sender: UIButton) {
        let controller = EditTextController()
        let model = EditText(text: scene.model.description)
        self.go(\.editTitle, controller: controller, model: model) { [weak self] textModel in
            guard let self = self else {return}
            self.scene.model.description = textModel.text
            self.descriptionLabel.text = textModel.text
            self.view.setNeedsLayout()
            self.scene.modelChanged()
        }
    }
    var scenePresenter: ScenePresenter { return self }
}
