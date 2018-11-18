//
//  AutoLayoutExtensions.swift
//  StoryCode
//
//  Created by Neil Allain on 11/17/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
  func addAutoLayoutSubviews(_ views: UIView ...) {
    views.forEach {
      self.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  static func spacer() -> UIView {
  	let spacerView = UIView()
		spacerView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		return spacerView
	}
}

