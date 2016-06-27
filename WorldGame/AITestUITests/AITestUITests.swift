//
//  AITestUITests.swift
//  AITestUITests
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

import XCTest

class AITestUITests : BaseUITestCase
{
    func testStartGame()
    {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Configure your game"].tap()
        tablesQuery.staticTexts["Setup Game"].tap()
    }

    func testLoadGame()
    {
        let tablesQuery = app.tables
        let newGameStaticText = tablesQuery.staticTexts["New Game"]
        newGameStaticText.tap()
        
        let quickStartStaticText = tablesQuery.staticTexts["Quick Start"]
        quickStartStaticText.tap()
        
        sleep(2)
        
        let setupButton = app.navigationBars["Game"].buttons["Setup"]
        setupButton.tap()
        
        // quit the game
        let saveButton = app.buttons["Save"]
        saveButton.tap()
        
        let enterYourNameTextField = app.textFields["Enter your name"]
        enterYourNameTextField.tap()
        app.typeText("game name")
        app.buttons["Save"].tap()
        
        let loadGameStaticText = tablesQuery.staticTexts["Load game"]
        loadGameStaticText.tap()
        
        sleep(2)
        
        let gameNameTest = tablesQuery.staticTexts["game name"]
        XCTAssert(gameNameTest.exists, "game name textfield not found")
    }
}
