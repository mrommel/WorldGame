//
//  RelationsNetwork.m
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "RelationsNetwork.h"

#import "Simulation.h"
#import "Group.h"
#import "GroupType.h"
#import "Policy.h"
#import "Situation.h"

/*!
 
 */
@interface RelationsNetwork()

@property (nonatomic) NSMutableArray *simulations;

@property (nonatomic) Simulation *lifeSpan;
@property (nonatomic) Simulation *workerProductivity;
@property (nonatomic) Simulation *gdp;
@property (nonatomic) Simulation *crimeRate;
@property (nonatomic) Simulation *violentCrimeRate;
@property (nonatomic) Simulation *foreignRelations;
@property (nonatomic) Simulation *immigration;
@property (nonatomic) Simulation *unemployment;
@property (nonatomic) Simulation *equality;
@property (nonatomic) Simulation *racialTension;
@property (nonatomic) Simulation *terrorism;
@property (nonatomic) Simulation *workingWeek;
@property (nonatomic) Simulation *povertyRate;
@property (nonatomic) Simulation *literacyRate;
@property (nonatomic) Simulation *internationalTrade;

// income
@property (nonatomic) Simulation *lowIncomeValue;
@property (nonatomic) Simulation *middleIncomeValue;
@property (nonatomic) Simulation *highIncomeValue;

// situation
@property (nonatomic) Situation *starvation;
@property (nonatomic) Situation *riot;

// groups
@property (nonatomic) Group *peopleAll;

@property (nonatomic) Group *peopleRetired;
@property (nonatomic) Group *peoplePeasant;
@property (nonatomic) Group *peopleWorker;
@property (nonatomic) Group *peopleNobile;
@property (nonatomic) Group *peopleStateEmployee;
@property (nonatomic) GroupType *groupWorking;

@property (nonatomic) Group *peopleWealthy;
@property (nonatomic) Group *peopleMiddleIncome;
@property (nonatomic) Group *peoplePoor;
@property (nonatomic) GroupType *groupIncome;

@property (nonatomic) Player *player;

@end


@implementation RelationsNetwork

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.simulations = [NSMutableArray new];
        
        // init all simulations
        self.lifeSpan = [[Simulation alloc] initWithName:@"Life Span" andDefaultValue:0.5f];
        [self.simulations addObject:self.lifeSpan];
        self.workerProductivity = [[Simulation alloc] initWithName:@"Worker Productivity" andDefaultValue:0.5f];
        [self.simulations addObject:self.workerProductivity];
        self.gdp = [[Simulation alloc] initWithName:@"GDP" andDefaultValue:0.5f];
        [self.simulations addObject:self.gdp];
        self.crimeRate = [[Simulation alloc] initWithName:@"Crime Rate" andDefaultValue:0.5f];
        [self.simulations addObject:self.crimeRate];
        self.violentCrimeRate = [[Simulation alloc] initWithName:@"Violent Crime Rate" andDefaultValue:0.01f];
        [self.simulations addObject:self.violentCrimeRate];
        self.foreignRelations = [[Simulation alloc] initWithName:@"Foreign Relations" andDefaultValue:0.5f];
        [self.simulations addObject:self.foreignRelations];
        self.immigration = [[Simulation alloc] initWithName:@"Immigration" andDefaultValue:0.0f];
        [self.simulations addObject:self.immigration];
        self.unemployment = [[Simulation alloc] initWithName:@"Unemployment" andDefaultValue:0.4f];
        [self.simulations addObject:self.unemployment];
        self.equality = [[Simulation alloc] initWithName:@"Equality" andDefaultValue:0.5f];
        [self.simulations addObject:self.equality];
        self.racialTension = [[Simulation alloc] initWithName:@"RacialTension" andDefaultValue:0.1f];
        [self.simulations addObject:self.racialTension];
        self.terrorism = [[Simulation alloc] initWithName:@"Terrorism" andDefaultValue:0.1f];
        [self.simulations addObject:self.terrorism];
        self.workingWeek = [[Simulation alloc] initWithName:@"WorkingWeek" andDefaultValue:0.5f];
        [self.simulations addObject:self.workingWeek];
        self.povertyRate = [[Simulation alloc] initWithName:@"PovertyRate" andDefaultValue:0.64f];
        [self.simulations addObject:self.povertyRate];
        self.literacyRate = [[Simulation alloc] initWithName:@"LiteracyRate" andDefaultValue:0.1f];
        [self.simulations addObject:self.literacyRate];
        self.internationalTrade = [[Simulation alloc] initWithName:@"InternationalTrade" andDefaultValue:0.5f];
        [self.simulations addObject:self.internationalTrade];
        
        // income
        self.lowIncomeValue = [[Simulation alloc] initWithName:@"lowIncomeValue" andDefaultValue:0.1f];
        [self.simulations addObject:self.lowIncomeValue];
        self.middleIncomeValue = [[Simulation alloc] initWithName:@"middleIncomeValue" andDefaultValue:0.1f];
        [self.simulations addObject:self.middleIncomeValue];
        self.highIncomeValue = [[Simulation alloc] initWithName:@"highIncomeValue" andDefaultValue:0.1f];
        [self.simulations addObject:self.highIncomeValue];
        
        // people
        self.peopleAll = [[Group alloc] initWithName:@"All" andGroupType:nil];
        
        self.groupWorking = [[GroupType alloc] initWithName:@"Working"];
        self.peoplePeasant = [[Group alloc] initWithName:@"Peasant" andGroupType:self.groupWorking];
        self.peopleWorker = [[Group alloc] initWithName:@"Worker" andGroupType:self.groupWorking];
        self.peopleNobile = [[Group alloc] initWithName:@"Nobile" andGroupType:self.groupWorking];
        self.peopleRetired = [[Group alloc] initWithName:@"Retired" andGroupType:self.groupWorking];
        self.peopleStateEmployee = [[Group alloc] initWithName:@"State Employees" andGroupType:self.groupWorking];
        
        self.groupIncome = [[GroupType alloc] initWithName:@"Income"];
        self.peoplePoor = [[Group alloc] initWithName:@"Poor" andGroupType:self.groupIncome];
        self.peopleMiddleIncome = [[Group alloc] initWithName:@"MiddleIncome" andGroupType:self.groupIncome];
        self.peopleWealthy = [[Group alloc] initWithName:@"Wealthy" andGroupType:self.groupIncome];
        
        // add connections to simulations
        [self.crimeRate addRelationWithFormula:@"0+(0.2*x)" toSimulation:self.povertyRate];
        [self.gdp addRelationWithFormula:@"-0.18+(x*0.36)" toSimulation:self.workerProductivity];
        [self.gdp addRelationWithFormula:@"0-(0.08*x)" toSimulation:self.crimeRate];
        [self.gdp addRelationWithFormula:@"-0.035+(0.035*x)" toSimulation:self.immigration];
        [self.immigration addRelationWithFormula:@"0.63*(x^4)" toSimulation:self.gdp withDelay:4];
        [self.internationalTrade addRelationWithFormula:@"0+(0.5*x)" toSimulation:self.foreignRelations withDelay:2];
        [self.racialTension addRelationWithFormula:@"0.3-(0.6*x)" toSimulation:self.foreignRelations];
        [self.racialTension addRelationWithFormula:@"0.92*(x^3)" toSimulation:self.immigration withDelay:2];
        [self.racialTension addRelationWithFormula:@"0+(0.22*x)" toSimulation:self.povertyRate];
        [self.terrorism addRelationWithFormula:@"0.24-(x*1)" toSimulation:self.foreignRelations];
        [self.terrorism addRelationWithFormula:@"-0.2+(x^4)" toSimulation:self.racialTension];
        [self.unemployment addRelationWithFormula:@"0.3*(x^3)" toSimulation:self.immigration];
        [self.unemployment addRelationWithFormula:@"0.6-(0.6*x)" toSimulation:self.gdp];
        [self.violentCrimeRate addRelationWithFormula:@"0.45*(x^6)" toSimulation:self.racialTension];
        [self.workerProductivity addRelationWithFormula:@"-0.15+(0.15*x)" toSimulation:self.lifeSpan];
        [self.workerProductivity addRelationWithFormula:@"-0.2+(x*0.4)" toSimulation:self.literacyRate];
        [self.workingWeek addRelationWithFormula:@"0+(0.2*x)" toSimulation:self.unemployment];
        
        // add connections to people
        [self.peopleAll addRelationTo:GroupValueMood withFormula:@"0-(0.13*x)" toSimulation:self.crimeRate];
        [self.peopleAll addRelationTo:GroupValueMood withFormula:@"0-(0.16*x)" toSimulation:self.violentCrimeRate];
        [self.peopleRetired addRelationTo:GroupValueMood withFormula:@"0-(0.18*x)" toSimulation:self.violentCrimeRate];
        [self.peopleRetired addRelationTo:GroupValueFreq withFormula:@"-0.3+(0.6*x)" toSimulation:self.lifeSpan];
        [self.peoplePoor addRelationTo:GroupValueMood withFormula:@"0.3-(x^2)" toSimulation:self.povertyRate];
        [self.peoplePoor addRelationTo:GroupValueFreq withFormula:@"-0.5+(1.0*x)" toSimulation:self.povertyRate];
        
        // topics
        // * slavery
        // * school duty
        // policy 'ausstattung'
        // garnisons
        // city self government
        // sauberkeit (strassenbau, strassenreinigung, kanalisation, stand der medizin) => simulation => birthrate
    }
    
    return self;
}

- (void)setPlayer:(Player *)player withEvent:(EventType)eventType
{
    self.player = player;
    
    [self.crimeRate addRelationWithFormula:@"0.2-(0.35*x)" toPolicy:self.player.policeForce withDelay:3];
    [self.equality addRelationWithFormula:@"0.1+(0.3*x)" toPolicy:self.player.inheritanceTax withDelay:8];
    [self.equality addRelationWithFormula:@"-0.1+(0.45*x)" toPolicy:self.player.incomeTax withDelay:4];
    [self.equality addRelationWithFormula:@"-0.15-(0.37*x)" toPolicy:self.player.salesTax];
    [self.highIncomeValue addRelationWithFormula:@"0-(0.20*x)" toPolicy:self.player.incomeTax];
    [self.highIncomeValue addRelationWithFormula:@"0-(0.12*x)" toPolicy:self.player.inheritanceTax];
    [self.literacyRate addRelationWithFormula:@"0.10+(0.35*x)" toPolicy:self.player.stateSchools withDelay:8];
    [self.lowIncomeValue addRelationWithFormula:@"0-(0.10*x)" toPolicy:self.player.incomeTax];
    [self.lowIncomeValue addRelationWithFormula:@"0-(0.12*x)" toPolicy:self.player.salesTax];
    [self.middleIncomeValue addRelationWithFormula:@"0-(0.14*x)" toPolicy:self.player.incomeTax];
    [self.middleIncomeValue addRelationWithFormula:@"0-(0.06*x)" toPolicy:self.player.salesTax];
    [self.povertyRate addRelationWithFormula:@"0.00+(0.20*x)" toPolicy:self.player.salesTax];
    [self.povertyRate addRelationWithFormula:@"-0.08-(0.10*x)" toPolicy:self.player.stateSchools];
    [self.unemployment addRelationWithFormula:@"0-(0.14*x)" toPolicy:self.player.stateSchools];
    [self.violentCrimeRate addRelationWithFormula:@"0.22-(0.52*x)" toPolicy:self.player.policeForce];
    
    [self.peopleRetired addRelationTo:GroupValueMood withFormula:@"0-(0.22*x)" toPolicy:self.player.inheritanceTax];
    [self.peopleMiddleIncome addRelationTo:GroupValueMood withFormula:@"0-(0.18*x)" toPolicy:self.player.inheritanceTax];
    [self.peopleMiddleIncome addRelationTo:GroupValueMood withFormula:@"0.27-(1.07*x)" toPolicy:self.player.incomeTax];
    [self.peopleWealthy addRelationTo:GroupValueMood withFormula:@"-0.1-(0.25*x)" toPolicy:self.player.inheritanceTax];
    [self.peopleWealthy addRelationTo:GroupValueMood withFormula:@"0-(x^11)" toPolicy:self.player.incomeTax];
    [self.peoplePoor addRelationTo:GroupValueMood withFormula:@"0.04+(0.11*x)" toPolicy:self.player.stateSchools];
    [self.peopleStateEmployee addRelationTo:GroupValueMood withFormula:@"-0.21+(0.52*x)" toPolicy:self.player.policeForce];
    [self.peopleStateEmployee addRelationTo:GroupValueFreq withFormula:@"-0.05+(0.1*x)" toPolicy:self.player.policeForce];
    [self.peopleStateEmployee addRelationTo:GroupValueMood withFormula:@"0.00+(0.18*x)" toPolicy:self.player.stateSchools];
    [self.peopleStateEmployee addRelationTo:GroupValueFreq withFormula:@"0+(0.1*x)" toPolicy:self.player.stateSchools];
    
#warning need to trigger something?
    if (eventType == EventTypeConquest) {
        // bad mood
    }
}

- (void)turn
{
    // calc
    for (Simulation *simulation in self.simulations) {
        [simulation turn];
        NSLog(@"%@", simulation);
    }
    
    [self.peopleAll turn];
    [self.peoplePeasant turn];
    [self.peopleWorker turn];
    [self.peopleNobile turn];
    [self.peopleRetired turn];
    [self.peoplePoor turn];
    [self.peopleMiddleIncome turn];
    [self.peopleWealthy turn];
    
    [self.groupWorking levelGroups];
    [self.groupIncome levelGroups];
    
    NSLog(@":: people ::::::::::::::::::::::::");
    NSLog(@"%@", self.peopleAll);
    NSLog(@"%@", self.peoplePoor);
    NSLog(@"%@", self.peopleMiddleIncome);
    NSLog(@"%@", self.peopleWealthy);
    NSLog(@"::::::::::::::::::::::::::");
    
    // add all values to the stack
    for (Simulation *simulation in self.simulations) {
        [simulation stack];
    }
    
    [self.peopleAll stack];
    [self.peoplePeasant stack];
    [self.peopleWorker stack];
    [self.peopleNobile stack];
    [self.peopleRetired stack];
    [self.peoplePoor stack];
    [self.peopleMiddleIncome stack];
    [self.peopleWealthy stack];
}

@end
