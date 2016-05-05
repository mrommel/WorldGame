//
//  MunicipalEntity.h
//  WorldGame
//
//  Created by Michael Rommel on 02.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 city or town
 
 - tech + policies => simulations => # of peoples => simulations
 
 - buildings: court, market, police, fire figthers, sanitation, water, electricity, gas, wall, fortress
 
 - question: should this get a major?
 - states (bits): boom, sieged, disease
 */
@interface MunicipalEntity : NSObject

@property (nonatomic, copy) NSString *name;
@property (atomic) NSInteger inhabitants;
@property (atomic) BOOL city;

- (instancetype)initWithName:(NSString *)name andInhabitants:(NSInteger)inhabitants;

@end

