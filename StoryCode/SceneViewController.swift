//
//  SceneViewController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/13/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import UIKit

/**
Default ScenePresenter implementations for UIViewControllers that are SceneControllers
*/
extension SceneController where Self: UIViewController {
	func pushScene<Controller: SceneController>(controller: Controller, options: SegueOptions) {
		guard let vc = controller as? UIViewController else { return }
		self.navigationController?.pushViewController(vc, animated: options.contains(.animated))
	}
	func popScene(options: SegueOptions) {
		self.navigationController?.popViewController(animated: options.contains(.animated))
	}
	func showModalScene<Controller: SceneController>(controller: Controller, options: SegueOptions) {
		guard let vc = controller as? UIViewController else { return }
		self.present(vc, animated: options.contains(.animated))
	}
	func dismissModalScene(options: SegueOptions) {
		self.dismiss(animated: options.contains(.animated))
	}
	func showDetailScene<Controller: SceneController>(controller: Controller, options: SegueOptions) {
		guard let vc = controller as? UIViewController else { return }
		self.splitViewController?.showDetailViewController(vc, sender: nil)
	}
}


