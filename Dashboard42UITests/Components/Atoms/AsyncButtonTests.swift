//
//  AsyncButtonTests.swift
//  Dashboard42UITests
//
//  Created by Marc MOSCA on 25/07/2024.
//

import SwiftUI
import XCTest

@testable import Dashboard42

final class AsyncButtonTests: XCTestCase {

    private var app: XCUIApplication!

    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func test_default_ShouldHaveRightTextLabel() throws {
        let greatings = app.staticTexts["greatings"]

        XCTAssertTrue(greatings.exists)
    }
}
