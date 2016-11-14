//
//  AISimulation.m
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AISimulation.h"

#import "CC3Math.h"
#import "Distribution.h"

@interface AISimulation()

@property (atomic) NSInteger samples;

@end

@implementation AISimulation

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // setup the properties
        self.foodSafety = [[AISimulationProperty alloc] initWithName:@"Food Safety"
                                                         explanation:@""
                                                       startingValue:0.8
                                                         andCategory:AISimulationCategoryEconomy];
        
        //
        // Soil categories
        //
        // Very poor             0 - 18              brown
        // Poor                 18 - 35              red
        // Medium               35 - 55              orange
        // High                 55 - 75              yellow
        // Very High            75 - 100             green
        //
        // Sand                                 0 - 11
        // Sandy loam                          11 - 30
        // Heavy to clayey loam                31 - 50
        // Loam, partly with loess covering    51 - 70
        // Loam with loess covering            71 - 90
        // Loess                               91 -100
        //
        self.soilQuality = [[AISimulationProperty alloc] initWithName:@"Soil Quality"
                                                          explanation:@""
                                                        startingValue:0.7
                                                          andCategory:AISimulationCategoryStatic];
        
        //self.hygiene
        
        self.externalAttraction = [[AISimulationProperty alloc] initWithName:@"External Attraction"
                                                                 explanation:@""
                                                               startingValue:0.1
                                                                 andCategory:AISimulationCategoryForeign];
        
        self.health = [[AISimulationProperty alloc] initWithName:@"Health"
                                                     explanation:@"A general indicator for the health of your citizens that measures not just raw lifespan, but also fitness and the general wellbeing of people."
                                                   startingValue:0.5
                                                     andCategory:AISimulationCategoryPublicServices];
        
        self.education = [[AISimulationProperty alloc] initWithName:@"Education"
                                                        explanation:@"A measurement of the education level of the average citizen. Not only literacy, but numeracy and general understanding of everything from history to IT and science.	"
                                                      startingValue:0.18
                                                        andCategory:AISimulationCategoryPublicServices];
        
        self.poverty = [[AISimulationProperty alloc] initWithName:@"Poverty"
                                                      explanation:@"One of the most widely used measures of comparison between nations. The poverty level is periodically reassessed, but all nations should strive to get their poverty rate as low as possible."
                                                    startingValue:0.64
                                                      andCategory:AISimulationCategoryWelfare];
        
        self.equality = [[AISimulationProperty alloc] initWithName:@"Equality"
                                                       explanation:@"There are many ways to measure equality. Conservatives talk of equality of opportunity, socialists talk of equality of outcome. This is just a simple measurement of the distribution of wealth (financial equality of outcome)."
                                                     startingValue:0.4
                                                       andCategory:AISimulationCategoryWelfare];
        
        self.crimeRate = [[AISimulationProperty alloc] initWithName:@"Crime Rate"
                                                        explanation:@"An indicator of the level of general non violent crime in your nation. This includes crimes such as car crime, burglary etc., but also covers fraud and other similar crimes."
                                                      startingValue:0.55
                                                        andCategory:AISimulationCategoryLawOrder];
        
        self.wages = [[AISimulationProperty alloc] initWithName:@"Wages"
                                                    explanation:@"The average wage level in your country. Wages are generally set by supply and demand, which roughly equates to the labor supply and the state of the economy (GDP). Immigration raises the labor supply, reducing wages, and high unemployment will also put downward pressure on wages. Labor laws, including minimum wages can push wages artificially higher, although this will have side-effects.	"
                                                  startingValue:0.5
                                                    andCategory:AISimulationCategoryLawOrder];
        
        self.incomeHigh = [[AISimulationProperty alloc] initWithName:@"High Income"
                                                         explanation:@"The effective income of the top earners in society. It is easy to reduce this by punitive taxes on the wealthy, their property, inheritance and activities such as air travel that they often indulge in. It is also possible to benefit them by offering tax exemptions and loopholes for the rich, or by favoring regressive taxation such as sales tax, rather than progressive income taxes.	"
                                                       startingValue:0.55
                                                         andCategory:AISimulationCategoryLawOrder];
        
        self.incomeMiddle = [[AISimulationProperty alloc] initWithName:@"Middle Income"
                                                           explanation:@"The effective income of those people on average earnings, not wealthy or poor. This is generally the largest group of people in the economy, so policies which affect this value can be big vote deciders. Middle income earners are expected to own their own homes (or be buying them), and often own one or more cars. They probably take holidays abroad at least once a year. Taxes that affect any of these will hit these people hardest, and may push some of them down into poverty	"
                                                         startingValue:0.55
                                                           andCategory:AISimulationCategoryLawOrder];
        
        self.incomeLow = [[AISimulationProperty alloc] initWithName:@"Low Income"
                                                        explanation:@"The effective income of those people who are on low (or no) earnings in our society. If this value rises high enough (through benefits and tax exemptions for the poor), then more people will move out of poverty and in to the middle income group. Progressive taxation, combined with well-funded public services and state benefits are the most popular ways to 'lift people' out of poverty.	"
                                                      startingValue:0.55
                                                        andCategory:AISimulationCategoryLawOrder];
        
        // don't forget to add new properties to the calculate step too
        
        self.propertyTax = [[AISimulationInput alloc] initWithName:@"Property tax"
                                                       explanation:@"Property tax is a tax levied on the value of homes. The valuation is often made by a government body, and the money is used to fund local government services (at least in part) such as the provision of street lighting and emergency services. Some see it as a fair tax which mostly affects those who own large homes and are wealthy, others see it as an unfair tax on retired people with large homes but little actual income."
                                                     startingValue:0.6
                                                       andCategory:AISimulationCategoryLawOrder];
        
        self.salesTax = [[AISimulationInput alloc] initWithName:@"Sales tax"
                                                   explanation:@"Sales tax is the classic 'regressive' tax, which means it does not take into account the ability to pay. Critics argue that this affects the poor disproportionately and thus increases inequality. Supporters argue that it is relatively easy to collect and affects everyone, and is thus fair. Businesses can be opposed to the administrative burden of the tax.	"
                                                 startingValue:0.3
                                                   andCategory:AISimulationCategoryLawOrder];
        
        self.policeForce = [[AISimulationInput alloc] initWithName:@"Police force"
                                                       explanation:@"Every government needs to employ a police force to ensure order is kept and laws are obeyed, but it's a matter of debate exactly how much should be spent on the police. Some favor a large force with police on every street corner, other prefer a more low-key and tolerant approach."
                                                     startingValue:0.6
                                                       andCategory:AISimulationCategoryLawOrder];
        
        self.sewage = [[AISimulationInput alloc] initWithName:@"Sewage"
                                                  explanation:@"public sewage system"
                                                startingValue:0.6
                                                  andCategory:AISimulationCategoryLawOrder];
        
        self.schools = [[AISimulationInput alloc] initWithName:@"StateSchools"
                                                   explanation:@"Free education for all ensures high levels of literacy and can be beneficial to the economy, especially those parts of the economy requiring a skilled workforce. The flipside of this is that state education can be expensive for the government. Wealthy individuals, not making use of state schools, may resent subsidizing them."
                                                 startingValue:0.6
                                                   andCategory:AISimulationCategoryLawOrder];
        
        //
        
        self.all = [[AISimulationGroup alloc] initWithName:@"All"
                                               explanation:@"A general group representing the interests of society as a whole, with opinions not related to a particular age group, gender or occupation.	"
                                         startingMoodValue:0.0
                                      andStartingFreqValue:1.0];
        
        self.poor = [[AISimulationGroup alloc] initWithName:@"Poor"
                                               explanation:@"Poor people are naturally far more dependent on welfare payments from the state than anybody else. They may also be worried about unemployment more than most, as they consider their jobs more vulnerable. Poor people also are in favor of any progressive tax system that redistributes money their way, such as taxes on luxury goods.	"
                                         startingMoodValue:0.0
                                      andStartingFreqValue:0.25];
        
        self.middle = [[AISimulationGroup alloc] initWithName:@"Middle income"
                                               explanation:@"Neither poor, nor wealthy, the average middle income earner works most of his life to pay for his or her house, probably can afford a good holiday each year and may own one or more cars. Middle income earners are often very sensitive to changes in income tax. They usually make up a large proportion of the voting population.	"
                                         startingMoodValue:0.0
                                      andStartingFreqValue:0.41];
        
        self.wealthy = [[AISimulationGroup alloc] initWithName:@"Wealthy"
                                               explanation:@"Some people in this group are rich through their own endeavors, others have inherited their wealth. This is a group of people who have a strong interest in certain tax issues, and will take their own financial interests into account when voting to a lesser or greater extent. It's worth noting that many people aspire to be more wealthy than they are, and thus taxing the wealthy can be unpopular, even with those not yet in this group.	"
                                         startingMoodValue:0.0
                                      andStartingFreqValue:0.09];
        
        // add relations
        [self.foodSafety addStaticInputValue:0.8];
        
        [self.soilQuality addStaticInputValue:0.7];
        
        [self.health addInputProperty:self.foodSafety withFormula:@"0.9*x"];
        
        [self.crimeRate addInputProperty:self.poverty withFormula:@"0.3*(x^2)" andDelay:4];
        [self.crimeRate addInputProperty:self.education withFormula:@"-0.12*(x^6)"];
        [self.crimeRate addInputProperty:self.policeForce withFormula:@"-0.35*(x^0.6)" andDelay:4];
        
        [self.externalAttraction addInputProperty:self.health withFormula:@"0.1*(x^6)"];
        
        [self.equality addInputProperty:self.propertyTax withFormula:@"0+(0.15*x)"];
        [self.equality addInputProperty:self.salesTax withFormula:@"-0.02-(0.32*x)"];
        
        [self.education addInputProperty:self.schools withFormula:@"0+(0.2*x)"];
        
        [self.wages addStaticInputValue:0.5];
        
        [self.poverty addInputProperty:self.salesTax withFormula:@"0.00+(0.20*x)"];
        
        [self.incomeLow addInputProperty:self.wages withFormula:@"-0.5+(1.0*x)"];
        [self.incomeLow addInputProperty:self.salesTax withFormula:@"0-(0.12*x)"];
        
        [self.incomeMiddle addInputProperty:self.wages withFormula:@"-0.3+(0.6*x)"];
        [self.incomeMiddle addInputProperty:self.salesTax withFormula:@"0-(0.06*x)"];
        
        [self.incomeHigh addStaticInputValue:0.5];
        
        //
        [self.all.mood addInputProperty:self.crimeRate withFormula:@"0.13*x"];
        [self.all.freq addStaticInputValue:1.0];
        
        [self.poor.mood addInputProperty:self.poverty withFormula:@"0.3-(x^2)"];
        [self.poor.freq addStaticInputValue:0.25];
        
        [self.middle.mood addInputProperty:self.propertyTax withFormula:@"0-(0.32*x)"];
        [self.middle.freq addStaticInputValue:0.41];
        
        [self.wealthy.mood addInputProperty:self.propertyTax withFormula:@"0-(x^11)"];
        [self.wealthy.freq addStaticInputValue:0.09];
    }
    
    return self;
}

- (void)calculate
{
    [self.foodSafety calculate];
    [self.soilQuality calculate];
    [self.health calculate];
    [self.poverty calculate];
    [self.crimeRate calculate];
    [self.equality calculate];
    [self.wages calculate];
    
    [self.incomeHigh calculate];
    [self.incomeMiddle calculate];
    [self.incomeLow calculate];
    
    [self.propertyTax calculate];
    [self.salesTax calculate];
    [self.policeForce calculate];
    [self.sewage calculate];
    [self.schools calculate];
    
    [self.all calculate];
    [self.poor calculate];
    [self.middle calculate];
    [self.wealthy calculate];
    
    self.samples++;
}

- (NSInteger)sampleCount
{
    return self.samples;
}

- (NSMutableArray *)voter
{
    NSMutableArray *voterArray = [NSMutableArray new];
    
    [voterArray addObject:@"All"];
    
    CGFloat wealthValue = RandomFloatBetween(0.0, 1.0);
    
    Distribution *wealthDistribution = [Distribution new];
    [wealthDistribution addObject:self.poor withPropability:[self.poor.freq valueWithoutDelay]];
    [wealthDistribution addObject:self.middle withPropability:[self.middle.freq valueWithoutDelay]];
    [wealthDistribution addObject:self.wealthy withPropability:[self.wealthy.freq valueWithoutDelay]];
    [wealthDistribution distribute];
    
    AISimulationGroup *group = (AISimulationGroup *)[wealthDistribution objectFromPropability:wealthValue];
    [voterArray addObject:group.name];
    
    return voterArray;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString new];
    
    [str appendFormat:@"{ AISimulation, turns: %ld", (long)self.samples];
    [str appendString:@", properties: ["];
    [str appendString:[self.foodSafety description]];
    [str appendString:@", "];
    [str appendString:[self.soilQuality description]];
    [str appendString:@", "];
    [str appendString:[self.health description]];
    [str appendString:@", "];
    [str appendString:[self.poverty description]];
    [str appendString:@", "];
    [str appendString:[self.crimeRate description]];
    [str appendString:@", "];
    [str appendString:[self.equality description]];
    [str appendString:@"] }"];
    
    return str;
}

@end
