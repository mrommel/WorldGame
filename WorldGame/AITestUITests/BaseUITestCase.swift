//
//  BaseUITestCase.swift
//  WorldGame
//
//  Created by Michael Rommel on 27.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

class BaseUITestCase : XCTestCase
{
    let app:XCUIApplication = XCUIApplication()
    
    // setup/teardown
    override func setUp()
    {
        super.setUp()
        continueAfterFailure = false
        
        app.launchEnvironment = ["animations": "0"]
        app.launch()
        
        XCUIDevice().orientation = .FaceUp
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func waitForAppToStart()
    {
        /*while (true) {
            let dashboardLabel = app.staticTexts["Dashboard"]
            let signInLabel = app.staticTexts["Sign In"]
            
            dismissHockeyUpdateAlert()
            
            if dashboardLabel.exists || signInLabel.exists {
                print("### App started ###")
                sleep(1)
                return
            }
            
            sleep(1)
        }*/
    }
    
    // utility methods
    func waitFor(element:XCUIElement, seconds waitSeconds:Double, file: String = #file, line: UInt = #line)
    {
        let exists = NSPredicate(format: "exists == 1")
        expectationForPredicate(exists, evaluatedWithObject: element, handler: nil)
        waitForExpectationsWithTimeout(waitSeconds) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
        }
    }
}