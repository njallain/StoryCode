//
//  ReadBookController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/17/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import UIKit
import StoryCodeKit

struct ReadBookScene: SceneDefinition {
	var name: String { return "read" }
	typealias Model = String
}

class ReadBookController: UIViewController, SceneController, ScenePresenter {
	
	var scene: Scene<ReadBookScene>!
	var scenePresenter: ScenePresenter { return self }
	var textView: UITextView!
	
	func setup(scene: Scene<ReadBookScene>) {
		self.scene = scene
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		textView = UITextView()
		view.addAutoLayoutSubviews(textView)
		let safeArea = view.safeAreaLayoutGuide
		textView.isEditable = false
		textView.isScrollEnabled = true
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
			textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
			textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
		])
		textView.text = scene.model
		// Do any additional setup after loading the view.
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
