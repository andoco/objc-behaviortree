//
//  Prey.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Prey.h"

#import "EatFood.h"
#import "Flee.h"
#import "Seek.h"
#import "PredatorDetected.h"
#import "Selector.h"
#import "Sequence.h"
#import "TargetFood.h"

@implementation Prey

- (id)init
{
    self = [super init];
    if (self) {
        self.color = [UIColor blueColor];
        self.speed = 3;
        
        id fleeSeq = [[Sequence alloc] init];
        [fleeSeq addChild:[[PredatorDetected alloc] initWithActor:self]];
        [fleeSeq addChild:[[Flee alloc] initWithActor:self]];
        
        id gatherSeq = [[Sequence alloc] init];
        [gatherSeq addChild:[[TargetFood alloc] initWithActor:self]];
        [gatherSeq addChild:[[Seek alloc] initWithActor:self]];
        [gatherSeq addChild:[[EatFood alloc] initWithActor:self]];
        
        id selector = [[Selector alloc] init];
        [selector addChild:fleeSeq];
        [selector addChild:gatherSeq];
        
        self.root = selector;
    }
    return self;
}

@end
