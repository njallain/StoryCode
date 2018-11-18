//
//  TestExtensions.swift
//  StoryCodeKitTests
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import XCTest

func assertEqual<T>(_ expression1: @autoclosure () throws -> T?,
	_ expression2: @autoclosure () throws -> T?,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file, line: UInt = #line) where T : Equatable {
	return XCTAssertEqual(expression1, expression2, message, file: file, line: line)
}

func assertTrue(
	_ expression: @autoclosure () throws -> Bool,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file, line: UInt = #line) {
	XCTAssertTrue(expression, message, file: file, line: line)
}

func assertFalse(
	_ expression: @autoclosure () throws -> Bool,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file, line: UInt = #line) {
	XCTAssertFalse(expression, message, file: file, line: line)
}


func assertFail(_ message: String = "", file: StaticString = #file, line: UInt = #line) {
	XCTFail(message, file: file, line: line)
}

func assertNil(
	_ expression: @autoclosure () throws -> Any?,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file, line: UInt = #line) {
	XCTAssertNil(expression, message, file: file, line: line)
}

func assertNotNil(
	_ expression: @autoclosure () throws -> Any?,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file, line: UInt = #line) {
	XCTAssertNotNil(expression, message, file: file, line: line)
}
