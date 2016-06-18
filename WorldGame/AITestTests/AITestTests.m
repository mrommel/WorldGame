//
//  AITestTests.m
//  AITestTests
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Unit.h"

@interface UnitTests : XCTestCase

@end

@implementation UnitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUnitCreation
{
    Unit *unit = [[Unit alloc] initWithType:@"Hoplites" atPosition:CGPointMake(0, 0) onMap:nil];
    XCTAssertNotNil(unit, @"Unit could not be created");
}

- (void)testUnitPromotion
{
    Unit *unit = [[Unit alloc] initWithType:@"Hoplites" atPosition:CGPointMake(0, 0) onMap:nil];
    
    // pre check
    XCTAssert(![unit hasPromotion:UnitPromotionEmbark], @"unit have the promotion already");
    
    [unit addPromotion:UnitPromotionEmbark];
    
    XCTAssert([unit hasPromotion:UnitPromotionEmbark], @"unit does not have the promotion");
}

- (void)testArmyCreation
{
    Army *army = [[Army alloc] initWithLeader:nil];
    XCTAssertNotNil(army, @"Army could not be created");
}

/*- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

@end
