//
//  SceneViewController.swift
//  StoryCode
//
//  Created by Neil Allain on 11/13/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import UIKit

extension SceneController where Self: UIViewController {
    func pushScene<Controller: SceneController>(controller: Controller, options: SegueOptions) {
        guard let vc = controller as? UIViewController else { return }
        self.navigationController?.pushViewController(vc, animated: options.contains(.animated))
    }
    func popScene(options: SegueOptions) {
        self.navigationController?.popViewController(animated: options.contains(.animated))
    }
    func showModalScene<Controller: SceneController>(controller: Controller, options: SegueOptions) {
        print("presenting modal scene")
        guard let vc = controller as? UIViewController else { return }
        self.present(vc, animated: options.contains(.animated))
    }
    func dismissModalScene(options: SegueOptions) {
        print("dismissing modal scene")
        self.dismiss(animated: options.contains(.animated))
    }
	
}
