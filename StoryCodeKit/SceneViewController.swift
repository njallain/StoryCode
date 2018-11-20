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
	public static func popoverMiddle() -> SegueStyle {
		return SegueStyle([.animated], popover: SegueViewPopover(sourceView: nil, sourceRect: .zero, arrow: .none))
	}
	public static func popoverFrom(view: UIView, arrow: UIPopoverArrowDirection = .none) -> SegueStyle {
		return SegueStyle([.animated], popover: SegueViewPopover(sourceView: view, sourceRect: view.bounds, arrow: arrow))
	}
}

public extension UIPopoverArrowDirection {
	static let none = UIPopoverArrowDirection(rawValue: 0)
}

public class SegueViewPopover: NSObject, SeguePopover {
	private var sourceView: UIView?
	private var sourceRect: CGRect
	private var arrow: UIPopoverArrowDirection
	
	fileprivate init(sourceView: UIView?, sourceRect: CGRect, arrow: UIPopoverArrowDirection) {
		self.sourceView = sourceView
		self.sourceRect = sourceRect
		self.arrow = arrow
	}
	public func setup(source: AnySceneController, destination: AnySceneController) {
		guard let sourceVc = source as? UIViewController, let destVc = destination as? UIViewController else { return }
		destVc.modalPresentationStyle = .popover
		guard let popover = destVc.popoverPresentationController else { return }
		popover.delegate = self
		popover.permittedArrowDirections = arrow
		popover.canOverlapSourceViewRect = true
		let view = self.sourceView ?? sourceVc.viewIfLoaded
		guard let sourceView = view else { return }
		popover.sourceView = sourceView
		popover.sourceRect = sourceRect != .zero ? sourceRect
			: CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 1, height: 1)
	}
}
extension SegueViewPopover: UIPopoverPresentationControllerDelegate {
	//func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle { // swift < 3.0
	public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		// Return no adaptive presentation style, use default presentation behaviour
		return .none
	}
}
