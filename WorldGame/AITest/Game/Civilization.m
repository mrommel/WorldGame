//
//  Civilization.m
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Civilization.h"

static NSString* const CivilizationDataNameKey = @"Civilization.Name";

@implementation Civilization

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.name = name;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        self.name = [decoder decodeObjectForKey:CivilizationDataNameKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:CivilizationDataNameKey];
}

@end

@interface CivilizationProvider()

@property (nonatomic) NSMutableArray *civilizations;

@end

@implementation CivilizationProvider

static CivilizationProvider *shared = nil;

+ (CivilizationProvider *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[CivilizationProvider alloc] init];
        }
    }
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.civilizations = [[NSMutableArray alloc] init];
        
        // fill with data
        Civilization *civilizationGerman = [[Civilization alloc] initWithName:@"German"];
        civilizationGerman.foregroundColor = [UIColor colorWithRed:0.145f green:0.169f blue:0.129f alpha:1.0f];
        civilizationGerman.backgroundColor = [UIColor colorWithRed:0.702f green:0.698f blue:0.722f alpha:1.0f];
        [self.civilizations addObject:civilizationGerman];
        
        Civilization *civilizationFrench = [[Civilization alloc] initWithName:@"French"];
        civilizationFrench.foregroundColor = [UIColor colorWithRed:0.922f green:0.922f blue:0.545f alpha:1.0f];
        civilizationFrench.backgroundColor = [UIColor colorWithRed:0.255f green:0.553f blue:0.996f alpha:1.0f];
        [self.civilizations addObject:civilizationFrench];
        
        Civilization *civilizationGreece = [[Civilization alloc] initWithName:@"Greece"];
        civilizationGreece.foregroundColor = [UIColor colorWithRed:0.255f green:0.553f blue:0.996 alpha:1.0f];
        civilizationGreece.backgroundColor = [UIColor colorWithRed:1.000f green:1.000f blue:1.000f alpha:1.0f];
        [self.civilizations addObject:civilizationGreece];
    }
    
    return self;
}

- (Civilization *)civilizationForName:(NSString *)civilizationName
{
    for (Civilization *civilization in self.civilizations) {
        if ([civilization.name isEqualToString:civilizationName]) {
            return civilization;
        }
    }
    
    return nil;
}

- (Civilization *)randomCivilization
{
    return [self.civilizations objectAtIndex:(arc4random() % self.civilizations.count)];
}

@end