//
//  AISimulationPropertyTests.m
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AISimulationProperty.h"

const static CGFloat                kInitialValue = 0.7;
const static AISimulationCategory   kInitialCategory = AISimulationCategoryStatic;

@interface AISimulationPropertyTests : XCTestCase

@property (nonatomic) AISimulationProperty *property;

@end

@implementation AISimulationPropertyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.property = [[AISimulationProperty alloc] initWithName:@"Test" startingValue:kInitialValue andCategory:kInitialCategory];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialProperties
{
    XCTAssertEqual(self.property.name, @"Test", @"name not set");
    XCTAssertEqualWithAccuracy([self.property valueWithoutDelay], kInitialValue, 0.05, @"value not set");
    XCTAssertEqual(self.property.category, kInitialCategory, @"category not set");
}

- (void)testStaticValueCalculation
{
    [self.property addStaticInputValue:kInitialValue];
    [self.property calculate];
    
    XCTAssertEqualWithAccuracy([self.property valueWithoutDelay], kInitialValue, 0.05, @"value not static");
}

- (void)testStaticValueDecreasingCalculation
{
    [self.property addStaticInputValue:kInitialValue - 0.1];
    [self.property calculate];
    
    XCTAssertEqualWithAccuracy([self.property valueWithoutDelay], kInitialValue - 0.05, 0.05, @"value not decreasing static");
    
    [self.property calculate];
    
    XCTAssertEqualWithAccuracy([self.property valueWithoutDelay], kInitialValue - 0.025, 0.05, @"value not decreasing static");
}

- (void)testDynamicValueCalculation
{
    AISimulationProperty *secondProperty = [[AISimulationProperty alloc] initWithName:@"Test2" startingValue:1.0 andCategory:AISimulationCategoryProduction];
    [secondProperty addStaticInputValue:1.0];
    
    [self.property addInputProperty:secondProperty withFormula:@"0.0+0.5*x"];
    [self.property calculate];
    
    XCTAssertEqualWithAccuracy([self.property valueWithoutDelay], 0.6, 0.05, @"value not calculated correctly");
}

@end
