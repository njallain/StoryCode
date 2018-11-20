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
public extension SceneController where Self: UIViewController {
	func pushScene<Controller: SceneController>(controller: Controller, style: SegueStyle) {
		guard let vc = controller as? UIViewController else { return }
		self.navigationController?.pushViewController(vc, animated: style.options.contains(.animated))
	}
	func popScene(style: SegueStyle) {
		self.navigationController?.popViewController(animated: style.options.contains(.animated))
	}
	func showModalScene<Controller: SceneController>(controller: Controller, style: SegueStyle) {
		guard let vc = controller as? UIViewController else { return }
		if style.options.contains(.popover) {
			style.popover?.setup(source: self, destination: controller)
		}
		self.present(vc, animated: style.options.contains(.animated))
	}
	func dismissModalScene(style: SegueStyle) {
		self.dismiss(animated: style.options.contains(.animated))
	}
	func showDetailScene<Controller: SceneController>(controller: Controller, style: SegueStyle) {
		guard let vc = controller as? UIViewController, let splitVc = self.splitViewController else { return }
		if let nav = vc.navigationController {
			splitVc.showDetailViewController(nav, sender: nil)
		} else {
			let nav = UINavigationController(rootViewController: vc)
			splitVc.showDetailViewController(nav, sender: nil)
		}
	}
}

public extension SegueStyle {
	public static func viewMiddle() -> SegueStyle {
		return SegueStyle([.animated], popover: SegueViewPopover())
	}
}
public class SegueViewPopover: NSObject, SeguePopover {
	private var sourceView: UIView? = nil
	private var sourceRect = CGRect.zero
	public func setup(source: AnySceneController, destination: AnySceneController) {
		guard let sourceVc = source as? UIViewController, let destVc = destination as? UIViewController else { return }
		destVc.modalPresentationStyle = .popover
		guard let popover = destVc.popoverPresentationController else { return }
		popover.delegate = self
		popover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		let view = self.sourceView ?? sourceVc.viewIfLoaded
		guard let sourceView = view else { return }
		popover.sourceView = sourceView
		popover.sourceRect = sourceRect != .zero ? sourceRect
			: CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 1, height: 1)
	}
	func setupSource(popover: UIPopoverPresentationController, source: UIViewController) {
		guard let presentingView = source.viewIfLoaded else { return }
		popover.sourceView = presentingView
		popover.sourceRect = CGRect(x: presentingView.bounds.midX, y: presentingView.bounds.midY, width: 1, height: 1)
	}
}
extension SegueViewPopover: UIPopoverPresentationControllerDelegate {
	//func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle { // swift < 3.0
	public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		// Return no adaptive presentation style, use default presentation behaviour
		return .none
	}
}
