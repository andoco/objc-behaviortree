//
//  World.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "World.h"

#import "Actor.h"
#import "Predator.h"
#import "Prey.h"

@implementation World

- (id)init
{
    self = [super init];
    if (self) {
        _food = [NSMutableArray array];
    }
    return self;
}

-(void) update {
    [_prey update];
    [_predator update];
}

@end
