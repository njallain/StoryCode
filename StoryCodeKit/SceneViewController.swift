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
		let finalController = style.presentation?.setup(source: self, destination: controller) ?? controller
		guard let vc = finalController as? UIViewController else { return }
		if let split = self.splitViewController {
			split.present(vc, animated: style.options.contains(.animated))
		} else {
			self.present(vc, animated: style.options.contains(.animated))
		}
	}
	
	func dismissModalScene(style: SegueStyle) {
		if let split = self.splitViewController {
			split.dismiss(animated: style.options.contains(.animated))
		} else {
			self.dismiss(animated: style.options.contains(.animated))
		}
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

/**
UIKit specific styles of presentation.
*/
public extension SegueStyle {
	public static func popoverMiddle() -> SegueStyle {
		return SegueStyle([.animated], popover: SegueViewPopover(sourceView: nil, sourceRect: .zero, arrow: .none))
	}
	public static func popoverFrom(view: UIView, arrow: UIPopoverArrowDirection = .none) -> SegueStyle {
		return SegueStyle([.animated], popover: SegueViewPopover(sourceView: view, sourceRect: view.bounds, arrow: arrow))
	}
	public static func transparent(cover viewToCover: UIView, in presentingView: UIView) -> SegueStyle {
		let frame = viewToCover.convert(viewToCover.bounds, to: presentingView)
		return transparent(frame: frame)
	}
	public static func transparent(size: CGSize) -> SegueStyle {
		let presentation = TransparentModalPresentation()
		presentation.presentationFrame = CGRect(origin: .zero, size: size)
		presentation.center = true
		return SegueStyle([.animated], popover: presentation)
	}
	public static func transparent(frame: CGRect) -> SegueStyle {
		let presentation = TransparentModalPresentation()
		presentation.presentationFrame = frame
		return SegueStyle([.animated], popover: presentation)
	}
}

public extension UIPopoverArrowDirection {
	static let none = UIPopoverArrowDirection(rawValue: 0)
}

public class SegueViewPopover: NSObject, SeguePresentation {
	private var sourceView: UIView?
	private var sourceRect: CGRect
	private var arrow: UIPopoverArrowDirection
	
	fileprivate init(sourceView: UIView?, sourceRect: CGRect, arrow: UIPopoverArrowDirection) {
		self.sourceView = sourceView
		self.sourceRect = sourceRect
		self.arrow = arrow
	}
	public func setup(source: AnySceneController, destination: AnySceneController) -> AnySceneController {
		guard let sourceVc = source as? UIViewController, let destVc = destination as? UIViewController else { return destination }
		destVc.modalPresentationStyle = .popover
		guard let popover = destVc.popoverPresentationController else { return destination }
		popover.delegate = self
		popover.permittedArrowDirections = arrow
		popover.canOverlapSourceViewRect = true
		let view = self.sourceView ?? sourceVc.viewIfLoaded
		guard let sourceView = view else { return destination }
		popover.sourceView = sourceView
		popover.sourceRect = sourceRect != .zero ? sourceRect
			: CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 1, height: 1)
		return destination
	}
}
extension SegueViewPopover: UIPopoverPresentationControllerDelegate {
	//func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle { // swift < 3.0
	public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		// Return no adaptive presentation style, use default presentation behaviour
		return .none
	}
}

/**
Wraps a modal view controller with a transparent background
*/
fileprivate class TransparentModalPresentation: UIViewController, SeguePresentation, AnySceneController {
	fileprivate var presentationFrame: CGRect = .zero
	fileprivate var center = false
	//private var border = CGSize(width: 5.0, height: 5.0)
	private var embedded: UIViewController!
	public func setup(source: AnySceneController, destination: AnySceneController) -> AnySceneController {
		guard let destVc = destination as? UIViewController else { return destination }
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
		self.embedded = destVc
		self.addChild(destVc)
		return self
	}
	
	public override func viewDidLoad() {
		view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
		var frame = presentationFrame
		if center {
			frame.origin = CGPoint(x: view.frame.midX - frame.midX, y: view.frame.midY - frame.midY)
		}
//		let shadowFrame = frame.insetBy(dx: -border.width, dy: -border.height)
		let shadowFrame = frame
		//let innerFrame = CGRect(origin: CGPoint(x: border.width, y: border.height), size: frame.size)
		let innerFrame = CGRect(origin: .zero, size: frame.size)
		let shadowView = UIView(frame: shadowFrame)
		shadowView.layer.shadowColor = UIColor.black.cgColor
		shadowView.layer.shadowOffset = CGSize.zero
		shadowView.layer.shadowOpacity = 0.5
		shadowView.layer.shadowRadius = 5
		shadowView.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
		embedded.view.frame = innerFrame
		embedded.view.layer.cornerRadius = 10.0
		embedded.view.layer.borderColor = UIColor.gray.cgColor
		embedded.view.layer.borderWidth = 0.5
		embedded.view.clipsToBounds = true
		embedded.view.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
		shadowView.addSubview(embedded.view)
		view.addSubview(shadowView)
	}
	
	private class BackgroundView: UIView {
		var backgroundRect = CGRect.zero
		var cornerRadius = 0
		public override func draw(_ rect: CGRect) {
			
		}
	}
}
