//
//  AISimulationTests.m
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AISimulation.h"

@interface AISimulationTests : XCTestCase

@property (nonatomic) AISimulation *simulation;

@end

@implementation AISimulationTests

- (void)setUp
{
    [super setUp];
    
    self.simulation = [[AISimulation alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimulationCompletness
{
    XCTAssertNotNil(self.simulation.foodSafety);
    XCTAssertNotNil(self.simulation.soilQuality);
    XCTAssertNotNil(self.simulation.health);
    
    NSLog(@"Simulation: %@", self.simulation);
}

- (void)testSoilQualityIsStatic
{
    CGFloat initialSoilQuality = [self.simulation.soilQuality valueWithoutDelay];
    
    [self.simulation calculate];
    XCTAssertEqualWithAccuracy([self.simulation.soilQuality valueWithoutDelay], initialSoilQuality, 0.05, @"soil quality is not static");

    [self.simulation calculate];
    [self.simulation calculate];
    XCTAssertEqualWithAccuracy([self.simulation.soilQuality valueWithoutDelay], initialSoilQuality, 0.05, @"soil quality is not static");
}

- (void)testFoodSimulation
{
    [self.simulation calculate];
    
    XCTAssertEqualWithAccuracy([self.simulation.foodSafety valueWithoutDelay], 0.4, 0.05, @"food not reset");
}

- (void)testVoters
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"Voter: %d", i);
        NSArray *arr = [self.simulation voter];
    
        for (NSString *voter in arr) {
            NSLog(@"Voter: %@", voter);
        }
    }
}

@end
