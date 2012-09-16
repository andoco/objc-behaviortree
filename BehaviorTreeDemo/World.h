//
//  World.h
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Predator;
@class Prey;

@interface World : NSObject

@property (nonatomic, strong) NSMutableArray *food;
@property (nonatomic, strong) Predator *predator;
@property (nonatomic, strong) Prey *prey;

-(void) update;

@end
