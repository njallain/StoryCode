//
//  EditTextController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/13/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import UIKit
import StoryCodeKit

struct EditTextScene: SceneDefinition {
	var name: String { return "editText" }
	typealias Model = EditText
	
}
class EditTextController: UIViewController, SceneController, ScenePresenter {
	var scenePresenter: ScenePresenter { return self }
	var scene: Scene<EditTextScene>!
	var textField: UITextView!
	var doneButton: UIButton!
	
	func setup(scene: Scene<EditTextScene>) {
		self.scene = scene
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textField = UITextView()
		doneButton = UIButton(type: .roundedRect)
		self.view.backgroundColor = .white
		self.textField.font = UIFont.preferredFont(forTextStyle: .body)
		self.doneButton.setTitle("Done", for: .normal)
//		let stackView = UIStackView(arrangedSubviews: [textField, doneButton])
//		stackView.distribution = .fillProportionally
//		stackView.alignment = .center
//		stackView.axis = .vertical
//		stackView.translatesAutoresizingMaskIntoConstraints = false
//		self.view.addSubview(stackView)
		textField.translatesAutoresizingMaskIntoConstraints = false
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(textField)
		view.addSubview(doneButton)
		let padding = CGFloat(10.0)
		let vpadding = CGFloat(25.0)
		let safeLayout = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: vpadding),
			textField.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -vpadding),
			textField.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
			textField.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: padding),
			doneButton.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -vpadding),
			doneButton.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
			doneButton.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: padding)
//			stackView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: padding),
//			stackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
//			stackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -padding),
//			stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
			//stackView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -padding),
			])
		self.textField.becomeFirstResponder()
		self.textField.text = scene.model.text
		
		self.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		
	}
	
	@objc func done(_ sender: UIButton) {
		scene.model.text = self.textField.text
		self.finish(scene.model)
	}
}
